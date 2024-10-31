import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String recipeTitle;
  final String description;
  final String ingredients;
  final String instructions;
  final int cookingTime;
  final String difficulty;
  final String videoTutorialLink;
  final String image; // Changed from Blob to String to store the image URL
  final String uploadedBy;
  final int status;

  Recipe({
    required this.recipeTitle,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.cookingTime,
    required this.difficulty,
    required this.videoTutorialLink,
    required this.image,
    required this.uploadedBy,
    required this.status,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    return Recipe(
      recipeTitle: data['recipeTitle'],
      description: data['description'],
      ingredients: data['ingredients'],
      instructions: data['instructions'],
      cookingTime: data['cookingTime'],
      difficulty: data['difficulty'],
      videoTutorialLink: data['videoTutorialLink'],
      image: data['image'], // Now expecting a URL in string format
      uploadedBy: data['uploadedBy'],
      status: data['status'],
    );
  }

  // Method to convert a Recipe instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'recipeTitle': recipeTitle,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'videoTutorialLink': videoTutorialLink,
      'image': image, // URL string
      'uploadedBy': uploadedBy,
      'status': status,
    };
  }
}
