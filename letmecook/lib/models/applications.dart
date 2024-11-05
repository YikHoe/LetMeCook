import 'package:cloud_firestore/cloud_firestore.dart';

class Applications {
  final String id;
  final String userid;
  final String fullname;
  final int age;
  final String occupation;
  final int yearsOfExp;
  final String status;
  final String reason;

  Applications({
    required this.id,
    required this.userid,
    required this.fullname,
    required this.age,
    required this.occupation,
    required this.yearsOfExp,
    required this.status,
    required this.reason,
  });

  factory Applications.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Applications(
      id: doc.id,  // Ensure ID is taken from doc.id
      userid: data['userid'] ?? '',
      fullname: data['fullname'] ?? '',
      age: data['age'] ?? 0,
      occupation: data['occupation'] ?? '',
      yearsOfExp: data['yearsOfExp'] ?? 0,
      status: data['status'] ?? "PENDING",
      reason: data['reason'] ?? '',
    );
  }

  // Method to convert a Recipe instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'fullname': fullname,
      'age': age,
      'occupation': occupation,
      'yearsOfExp': yearsOfExp,
      'status': status,
      'reason': reason,
    };
  }
}
