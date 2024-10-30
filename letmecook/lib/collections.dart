import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Define collection references using final
final CollectionReference userCollection = _firestore.collection('users');
