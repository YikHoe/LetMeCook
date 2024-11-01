import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:letmecook/models/users.dart';
import 'package:letmecook/models/applications.dart';
import 'dart:typed_data';
import 'package:letmecook/repositories/user_repository.dart';

class ApplicationsRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> addApplication(
    String fullname,
    int age,
    String occupation,
    int yearsOfExp,
  ) async {
    try {
      // Get current user
      final auth.User? user = _firebaseAuth.currentUser;
      if (user == null) return 'You must be logged in to upload a recipe.';

      // Fetch user data from Firestore to get user role
      final User? userData = await UserRepository().getUserData(user.uid);
      if (userData == null) return 'User data not found.';

      // Create a new recipe object
      Applications application = Applications(
          id: '',
          userid: user.uid,
          fullname: fullname,
          age: age,
          occupation: occupation,
          yearsOfExp: yearsOfExp,
          status: 'PENDING'
      );

      // Add the recipe to Firestore and get the document reference
      DocumentReference docRef = _firestore
          .collection('applications')
          .doc(); // Generate a new document reference
      application = Applications(
          id: docRef.id,
          userid: user.uid,
          fullname: fullname,
          age: age,
          occupation: occupation,
          yearsOfExp: yearsOfExp,
          status: 'PENDING'
      );

      // Add the application to Firestore
      await docRef.set(application.toJson()); // Use set() to specify the ID
      return 'Application submitted.';
    } catch (e) {
      return 'An error occurred while submitting the application. Please try again later.';
    }
  }
}