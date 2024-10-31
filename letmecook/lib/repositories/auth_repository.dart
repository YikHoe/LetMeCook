import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:letmecook/collections.dart';
import 'package:letmecook/models/users.dart';

class AuthRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user
  auth.User? get currentUser => _firebaseAuth.currentUser;

  // Sign up with email and password, including validation and Firestore storage
  Future<String?> signUpWithEmail(String username, String email,
      String password, String confirmPassword) async {
    // Input validation
    if (username.isEmpty) return 'Please enter a username.';
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    if (password.isEmpty || password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }

    try {
      // Firebase Auth user creation
      final auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final auth.User? user = userCredential.user;

      if (user != null) {
        // Store additional user data in Firestore
        User newUser = User(
          username: username,
          email: email,
          user_role: 'normal_user',
        );

        await userCollection.doc(user.uid).set(newUser.toJson());
      }

      return null; // Return null if the sign-up was successful
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The email is already in use by another account.';
      } else if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else {
        return 'An error occurred, please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred, please try again.';
    }
  }

  // Sign in with email and password, including validation and Firestore role check
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      // Firebase Auth sign-in
      final auth.UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final auth.User? user = userCredential.user;
      if (user != null) {
        // Retrieve user role from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        String userRole = userDoc.get('user_role');

        // Return the user role for routing purposes
        return userRole;
      }
      return null; // Return null if user or role is not found
    } on auth.FirebaseAuthException catch (e) {
      return 'Incorrect email or password, please try again.';
    } catch (e) {
      return 'An unexpected error occurred, please try again.';
    }
  }

  // Sign out
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get currently signed-in user
  auth.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
