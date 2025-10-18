import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Auth_Provider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String? userType,
    String? department,
    String? medicalRecord,
    String? medicineTaken,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final String uid = userCredential.user!.uid;

      Map<String, dynamic> userData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (userType == 'Doctor') {
        userData['department'] = department ?? '';
      } else if (userType == 'patient') {
        userData['medicalRecord'] = medicalRecord ?? '';
        userData['medicineTaken'] = medicineTaken ?? '';
      }

      await _firestore.collection('users').doc(uid).set(userData);

      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Register done🎉'.tr)),
      );

      Navigator.pushReplacementNamed(context,'/home');

    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? 'Register error'.tr;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = 'fail in login'.tr;
      if (e.code == 'user-not-found') {
        message = 'UserName is not found '.tr;
      } else if (e.code == 'wrong-password') {
        message = 'Password is not correct'.tr;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

