import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:letmecook/models/recipes.dart';
import 'package:letmecook/models/users.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:letmecook/repositories/user_repository.dart';

class RecipeRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> addRecipe(
      String recipeTitle,
      String description,
      String ingredients,
      String instructions,
      int cookingTime,
      String difficulty,
      String videoTutorialLink,
      {Uint8List? imageBytes,
      XFile? imageFile}) async {
    if (videoTutorialLink.isNotEmpty &&
        !Uri.parse(videoTutorialLink).isAbsolute) {
      return 'Please enter a valid video tutorial link.';
    }

    try {
      // Get current user
      final auth.User? user = _firebaseAuth.currentUser;
      if (user == null) return 'You must be logged in to upload a recipe.';

      // Fetch user data from Firestore to get user role
      final User? userData = await UserRepository()
          .getUserData(user.uid); // Remove the 'as User?' cast
      if (userData == null) return 'User data not found.';

      // Image upload to Firebase Storage
      String imageUrl = '';
      final String imagePath =
          'recipe_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (imageBytes != null) {
        final uploadTask = await _firebaseStorage
            .ref(imagePath)
            .putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
        imageUrl = await uploadTask.ref.getDownloadURL();
      } else if (imageFile != null) {
        final uploadTask = await _firebaseStorage.ref(imagePath).putFile(
            File(imageFile.path), SettableMetadata(contentType: 'image/jpeg'));
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      // Determine recipe status based on user role
      // If user role is admin, recipeStatus is 1, which means recipe upload is auto approved by default
      int recipeStatus = userData.user_role == "admin" ? 1 : 0;

      Recipe recipe = Recipe(
        recipeTitle: recipeTitle,
        description: description,
        ingredients: ingredients,
        instructions: instructions,
        cookingTime: cookingTime,
        difficulty: difficulty,
        videoTutorialLink: videoTutorialLink,
        image: imageUrl,
        uploadedBy: user.email!,
        status: recipeStatus,
      );

      await _firestore.collection('recipes').add(recipe.toJson());
      if (recipeStatus == 1) {
        return "admin";
      } else if (recipeStatus == 0) {
        return "verifiedUser";
      } else {
        return null;
      }
    } catch (e) {
      return 'An error occurred while uploading the recipe. Please try again.';
    }
  }

  Future<List<Recipe>> getPendingApprovalRecipes() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('recipes')
          .where('status', isEqualTo: 0)
          .get();

      List<Recipe> recipes = querySnapshot.docs.map((doc) {
        return Recipe.fromFirestore(doc);
      }).toList();

      return recipes;
    } catch (e) {
      print("Error fetching pending approval recipes: $e");
      return [];
    }
  }

Future<List<Map<String, dynamic>>> getRecipesWithUsernames() async {
  List<Map<String, dynamic>> recipesWithUsernames = [];

  try {
    // Fetch recipes with status 0 (pending approval)
    QuerySnapshot recipeSnapshot = await _firestore
        .collection('recipes')
        .where('status', isEqualTo: 0)
        .get();

    for (var recipeDoc in recipeSnapshot.docs) {
      // Convert recipeDoc to Recipe object
      Recipe recipe = Recipe.fromFirestore(recipeDoc);

      // Fetch the user data based on the email from the recipe's 'uploadedBy' field
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: recipe.uploadedBy)
          .get();

      String username = 'Unknown';
      if (userSnapshot.docs.isNotEmpty) {
        // Extract the username from the user's document
        Map<String, dynamic> userData =
            userSnapshot.docs.first.data() as Map<String, dynamic>;
        username = userData['username'] ?? 'Unknown';
      }

      recipesWithUsernames.add({
        'recipeTitle': recipe.recipeTitle,
        'description': recipe.description,
        'ingredients': recipe.ingredients,
        'instructions': recipe.instructions,
        'cookingTime': recipe.cookingTime,
        'difficulty': recipe.difficulty,
        'videoTutorialLink': recipe.videoTutorialLink,
        'image': recipe.image,
        'username': username,
      });
    }
  } catch (e) {
    print("Error fetching recipes with usernames: $e");
  }

  return recipesWithUsernames;
}
}
