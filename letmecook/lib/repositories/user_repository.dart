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
}