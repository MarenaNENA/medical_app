import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mdicalapp_1/screens/doctor_homescreen.dart';
//import 'package:flutter_mdicalapp_1/screens/doctor_homescreen.dart';
import 'package:flutter_mdicalapp_1/screens/patiant_homescreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  String? userType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserType();
  }

  Future<void> fetchUserType() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        userType = doc.data()?['userType'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (userType == 'Doctor') {
     return DoctorHomeScreen();
    } else if (userType == 'patient') {
      return PatientHomeScreen();
    } else {
      return Scaffold(body: Center(child: Text('User type not found')));
    }
  }
}
