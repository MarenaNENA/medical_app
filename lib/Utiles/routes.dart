import 'package:flutter/material.dart';
import 'package:flutter_mdicalapp_1/screens/registerscreen.dart';
import 'package:flutter_mdicalapp_1/screens/splaishScreen.dart';
import 'package:flutter_mdicalapp_1/screens/loginScreen.dart';
import 'package:flutter_mdicalapp_1/screens/homeScreen.dart';
import 'package:flutter_mdicalapp_1/screens/NotivicationScreen.dart';

class APPRoutes {
  static const String splaish = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String HomeScreen = '/home';
  static const String NotificationsScreen = '/notification';

   static Map<String, WidgetBuilder> routes = {
    splaish : (context) =>  Splaishscreen(),
    login: (context) => LoginScreen(),
    register: (context) => Registerscreen(),
    HomeScreen:(context)=> Home(),
    NotificationsScreen:(context)=>NotificationssScreen(),
  };
}
