import 'package:flutter/material.dart';
import 'package:flutter_mdicalapp_1/providers/doctor_provider.dart';
import 'package:flutter_mdicalapp_1/servces/translate.dart';
import 'package:provider/provider.dart';
import 'Utiles/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/auth_providers.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( 
  MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => Auth_Provider()),
    ChangeNotifierProvider(create: (_) => DoctorProvider()),
  ],
  child: MyApp(),
));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Medico',
      initialRoute:APPRoutes.splaish,
      routes: APPRoutes.routes,
      translations: MyTranslations(), 
      locale: Locale('en'), 
      fallbackLocale: Locale('en'),
    );
  }
}

