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

  // save and store application submitted by user
  Future<Map<String, dynamic>> addApplication(
    String fullname,
    int age,
    String occupation,
    int yearsOfExp,
  ) async {
    Map<String, dynamic> returnMessage = {};
    try {
      // Get current user
      final auth.User? user = _firebaseAuth.currentUser;
      if (user == null) {
        returnMessage['status'] = 404;
        returnMessage['message'] = 'Please login to proceed';
        return returnMessage;
      }

      // Fetch user data from Firestore to get user role
      final User? userData = await UserRepository().getUserData(user.uid);
      if (userData == null) {
        returnMessage['status'] = 404;
        returnMessage['message'] = 'User data not found!';
        return returnMessage;
      }

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
      returnMessage['status'] = 200;
      returnMessage['message'] = 'Application form submitted successfully';
      return returnMessage;
    } catch (e) {
      returnMessage['status'] = 500;
      returnMessage['message'] = 'Application Error';
      return returnMessage;
    }
  }

  // Check if user have pending application
  Future<Map<String, dynamic>> checkPending() async {
    Map<String, dynamic> applicationRecord = {};

    try {
      // Get current user
      final auth.User? user = _firebaseAuth.currentUser;
      if (user == null) {
        applicationRecord['message'] = 'Login to view application.';

        return applicationRecord;
      }

      // Fetch user data from Firestore to get user role
      final User? userData = await UserRepository().getUserData(user.uid);
      if (userData == null) {
        applicationRecord['message'] = 'User not found!';

        return applicationRecord;
      }

      applicationRecord['message'] = 200;

      try {
        QuerySnapshot pendingApplication = await _firestore
            .collection('applications')
            .where('userid', isEqualTo: user.uid)
            .where('status', isEqualTo: 'PENDING')
            .get();

        if (pendingApplication.docs.isNotEmpty) {
          applicationRecord['hasPending'] = true;
        } else {
          applicationRecord['hasPending'] = false;
        }

        return applicationRecord;
      } catch (e) {
        applicationRecord['message'] = 'Unexpected Error occurred. Please try again later.';
        return applicationRecord;
      }
    } catch (e) {
      applicationRecord['message'] = 'Unexpected Error occurred. Please try again later.';
      return applicationRecord;
    }
  }
}