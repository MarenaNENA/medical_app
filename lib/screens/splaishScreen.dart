import 'package:flutter/material.dart';
import 'package:flutter_mdicalapp_1/Utiles/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Splaishscreen extends StatefulWidget{

  const Splaishscreen({super.key});

  @override
  State<Splaishscreen> createState()=> _splaishScreenstate();
}
class  _splaishScreenstate extends State<Splaishscreen>{
 
 @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, APPRoutes.login);
      }
    });
  }
  @override
 Widget build (BuildContext context){
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/image/logo.png',
              width: MediaQuery.of(context).size.width *0.5,
              height:MediaQuery.of(context).size.width *0.5,
            ),
          ] 
        ),
    )
  );
 }
}