import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String user_role;
  final String username;

  User({
    required this.email,
    required this.user_role,
    required this.username,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      email: data['email'],
      user_role: data['user_role'],
      username: data['username'],
    );
  }

  // Method to convert a User instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'user_role': user_role,
      'username': username,
    };
  }
}