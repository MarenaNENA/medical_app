import 'package:flutter/material.dart';
import 'package:flutter_mdicalapp_1/Utiles/validators.dart';
import 'package:flutter_mdicalapp_1/providers/auth_providers.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Registerscreen extends StatefulWidget {
 const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Registerscreen>{

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstTextController = TextEditingController();
  final TextEditingController _SecondTextController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _medicalRecordController = TextEditingController();
  final TextEditingController _medicineController = TextEditingController();

  String? _SelectType;
  String? _SelectSpecialization;

  final List<String> specializations = [
  'Cardiology'.tr,'Neurology'.tr,'Pediatrics'.tr,'Orthopedics'.tr,'Oncology'.tr,'Radiology'.tr,'Internal Medicine'.tr,'General Surgery'.tr,
  'Dermatology'.tr,'Psychiatry'.tr,'Ophthalmology'.tr,'ENT'.tr,'Gynecology'.tr,'Urology'.tr,'Anesthesiology'.tr,'Family Medicine'.tr,
  'Emergency Medicine'.tr,
];

  @override
 Widget build(BuildContext context){
  return Scaffold(
  backgroundColor: Colors.black,
    appBar: AppBar(
       backgroundColor: Colors.blueAccent,
      title: Text('Register'.tr,style: TextStyle(fontSize: 20),),
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
              controller: _firstTextController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'First Name'.tr,
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
                ),
              validator: Validators.validateRequired,
            ),
            const SizedBox(height: 20),
             TextFormField(
              controller: _SecondTextController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Second Name'.tr,
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
                ),
              validator: Validators.validateRequired,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              style: TextStyle(color: Colors.white),
              dropdownColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Type'.tr,
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
                ),
              value: _SelectType,
              items:['Doctor','patient']
              .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
               )).toList(),
               onChanged: (value){
                setState(() {
                  _SelectType = value;
                });
               },
               validator: (value)=> value == null?'please select a type' : null,
               ),
               if (_SelectType == 'patient') ...[
                const SizedBox(height: 20),
                TextFormField(
                  controller: _medicalRecordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText:'Medical Record'.tr,
                    labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                    )
                    ),
                ),
                const SizedBox(height: 20),
                 TextFormField(
                  controller: _medicineController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText:'Medicine Taken'.tr,
                    labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                  )
                ),
              )
            ],
               if (_SelectType == 'Doctor') ...[
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Specialization'.tr,
                    labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                    )
                    ),
                  value: _SelectSpecialization,
                  items: specializations 
                  .map((spec)=>DropdownMenuItem(
                    value: spec,
                    child:Text(spec),
                     ))
                    .toList(),
                  onChanged: (value){
                    setState(() {
                      _SelectSpecialization = value;
                    });
                  },
                  validator: Validators.validateDepartment,
                  )
               ],
               const SizedBox(height: 20),
               TextFormField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
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
              onPressed: ()async{
                if (_formKey.currentState!.validate()) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registering...'.tr)),
                );
                Provider.of<Auth_Provider>(context, listen: false). registerUser(
                     email: _emailController.text.trim(),
                     password: _passwordController.text.trim(),
                     firstName: _firstTextController.text.trim(),
                     lastName: _SecondTextController.text.trim(),
                     department: _SelectType == 'Doctor' ? _SelectSpecialization : null,
                     medicalRecord: _SelectType == 'patient' ? _medicalRecordController.text.trim() : null,
                     medicineTaken:_SelectType == 'patient' ? _medicineController.text.trim() : null,
                     userType: _SelectType,
                     context: context, 
                   );
                }
              }, 
              child:Text('Register'.tr),
            )
          ],
        )
      )
    ),
  );
 }
 }