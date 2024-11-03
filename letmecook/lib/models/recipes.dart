import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id; // This will hold the document ID
  final String recipeTitle;
  final String description;
  final String ingredients;
  final String instructions;
  final int cookingTime;
  final String difficulty;
  final String videoTutorialLink;
  final String image;
  final String uploadedBy;
  final int status;

  Recipe({
    required this.id,
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
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,  // Ensure ID is taken from doc.id
      recipeTitle: data['recipeTitle'] ?? '',
      description: data['description'] ?? '',
      ingredients: data['ingredients'] ?? '',
      instructions: data['instructions'] ?? '',
      cookingTime: data['cookingTime'] ?? '',
      difficulty: data['difficulty'] ?? '',
      videoTutorialLink: data['videoTutorialLink'] ?? '',
      image: data['image'] ?? '',
      uploadedBy: data['uploadedBy'] ?? '',
      status: data['status'] ?? 0,
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
