import 'package:flutter/material.dart';
import 'package:flutter_mdicalapp_1/Utiles/validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mdicalapp_1/providers/auth_providers.dart';
import 'package:get/get.dart';



class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
 Widget build(BuildContext content){
  return Scaffold(
     backgroundColor: Colors.black, 
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Login'.tr),
         actions: [
    IconButton(
        icon: const Icon(Icons.language, color: Colors.white),
        onPressed: () {
          // تغيير اللغة فورًا
          if (Get.locale?.languageCode == 'en') {
            Get.updateLocale(Locale('ar'));
          } else {
            Get.updateLocale(Locale('en'));
          }
        },
        tooltip: 'Language'.tr, // لو حابب Tooltip
      ),
  ],
      ),

      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form (
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              decoration:  InputDecoration(
                labelText: 'Email'.tr,
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                  )
                  ),
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password'.tr,
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                  )
                  ),
              validator: Validators.validatepassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.pinkAccent,
               foregroundColor: Colors.white,
              ),
              onPressed: (){
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('login...'.tr)),
                  );
                 Provider.of<Auth_Provider>(context, listen: false).loginUser(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context,
                );
                }
              }, 
              child:Text('Login'.tr),
           ),
           Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
           Text(
              "Don't have an account?".tr,
              style: TextStyle(color: Colors.white70),
           ),
           TextButton(
             onPressed: () {
                Navigator.pushNamed(context, '/register');
             },
             child: Text(
                 'Register'.tr,
               style: TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
       ),

          ]
        )
      )
    )
  );
 }
}