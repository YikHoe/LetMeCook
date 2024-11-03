import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letmecook/collections.dart';
import 'package:letmecook/models/users.dart';

class UserRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user
  auth.User? get currentUser => _firebaseAuth.currentUser;

  // Fetch user data from Firestore
  Future<User?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Check if a recipe is saved for the current user
  Future<bool> isRecipeSaved(String recipeId) async {
    try {
      final uid = currentUser?.uid;
      if (uid == null) return false;

      final doc = await userCollection
          .doc(uid)
          .collection('savedRecipes')
          .doc(recipeId) // Use recipeId as the document ID
          .get();

      return doc.exists; // Returns true if the recipe is saved
    } catch (e) {
      print('Error checking saved recipe: $e');
      return false;
    }
  }

// Save or unsave a recipe for the current user
  Future<String> toggleRecipeSaved(String recipeId) async {
    try {
      final uid = currentUser?.uid;
      if (uid == null) return 'User not logged in.';

      final docRef =
          userCollection.doc(uid).collection('savedRecipes').doc(recipeId);

      final doc = await docRef.get();
      if (doc.exists) {
        // Recipe is already saved, unsave it
        await docRef.delete();
        return 'Recipe unsaved successfully!';
      } else {
        // Recipe is not saved, save it
        await docRef.set({
          'savedAt': Timestamp.now(), // You can store additional data if needed
        });
        return 'Recipe saved successfully!';
      }
    } catch (e) {
      print('Error toggling saved recipe: $e');
      return 'Error occurred while saving recipe.';
    }
  }

Future<List<Map<String, dynamic>>> getSavedRecipes() async {
  try {
    final uid = currentUser?.uid;
    if (uid == null) return [];

    // Fetch all saved recipes for the user
    final savedRecipesSnapshot =
        await userCollection.doc(uid).collection('savedRecipes').get();

    List<Map<String, dynamic>> savedRecipes = [];

    for (var savedRecipeDoc in savedRecipesSnapshot.docs) {
      final recipeId =
          savedRecipeDoc.id; // Use the document ID as the recipe ID

      // Fetch recipe details from the main `recipes` collection
      final recipeDoc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();

      if (recipeDoc.exists) {
        final recipeData = recipeDoc.data() as Map<String, dynamic>;

        // Fetch uploader's username from the `users` collection based on email
        final uploaderEmail = recipeData['uploadedBy'] ?? '';
        final userQuerySnapshot = await userCollection
            .where('email', isEqualTo: uploaderEmail)
            .limit(1)
            .get();

        String uploaderName = 'Unknown Author';
        if (userQuerySnapshot.docs.isNotEmpty) {
          uploaderName =
              userQuerySnapshot.docs.first['username'] ?? uploaderName;
        }

        // Include the entire recipe data along with uploader details
        savedRecipes.add({
          'id': recipeId,
          ...recipeData, // Spread the recipe data to include all fields
          'uploadedBy': uploaderName, // Add uploader name
        });
      }
    }

    return savedRecipes;
  } catch (e) {
    print('Error fetching saved recipes: $e');
    return [];
  }
}

}
