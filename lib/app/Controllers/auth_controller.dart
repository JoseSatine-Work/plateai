import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/app/Models/profile.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerNewUser(UserProfile profile, String password) async {
    try {
      // Validate inputs before proceeding
      if (profile.email.isEmpty || password.isEmpty) {
        return "Email and password cannot be empty";
      }

      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: profile.email,
        password: password,
      );

      User? user = userCredential.user;

      print("User ID: ${user?.uid}");

      if (user != null) {
        await user.updateDisplayName(profile.userName);

        // Convert profile to map and store in Firestore
        await _firestore.collection('db').doc(user.uid).set({
          ...profile.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        return "success";
      }

      return "Failed to create user profile";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Registration failed";
    } catch (e) {
      return "An unexpected error occurred";
    }
  }
}
