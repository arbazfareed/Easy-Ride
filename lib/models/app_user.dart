// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // Needed for fromFirestore/toFirestore

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final DateTime createdAt;
  // Add other user-specific fields here as your app grows
  // For example:
  // final String? profileImageUrl;
  // final List<String> roles; // e.g., ['driver', 'passenger']

  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.createdAt,
    // Initialize other fields here
  });

  // Factory constructor to create a UserModel from a Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id, // The document ID is typically the user's UID
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      phone: data['phone'] as String,
      email: data['email'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      // Parse other fields
    );
  }

  // Method to convert a UserModel instance into a Map for Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      // 'uid': uid, // UID is usually the document ID, so no need to store it redundantly inside the document
      'createdAt': Timestamp.fromDate(createdAt), // Convert DateTime to Timestamp for Firestore
      // Add other fields to be stored
    };
  }

  // Optional: A copyWith method for immutability
  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
