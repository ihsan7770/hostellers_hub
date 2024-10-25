

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'spalsh.dart';
import 'Admin/admin.dart';
import 'Admin/Userdetails.dart';
import 'Admin/manageproduct.dart';
import 'Admin/orderdproducts.dart';
import 'Admin/viewfeedback.dart';
import 'Admin/admin_notification.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'User/sell.dart';
import 'User/Myproducts.dart';
import 'User/sendfeedback.dart';
import 'User/myorders.dart';
import 'User/usernotification.dart';
import 'User/expantproduct.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'home',
    routes: {
      'splash': (context) => SplashVeiw(),
      'login': (context) => login(),
      'register': (context) => register(),
      'home': (context) => home(),
      'admin': (context) => admin(),
      'userdetails': (context) => userdetails(),
      'manageproduct': (context) => manageproduct(),
      'orderdproducts': (context) => orderedproduct(),
      'viewfeedback': (context) => viewfeedback(),
      'AdminNoti':(context) => AdminNoti(),
      'sendfeedback': (context) => sendfeedback(),
      'sell': (context) => sell(),
      'myorders': (context) => myorders(),
      'UserNotification':(context) =>  UserNotification(),
      'ExpandProduct':(context)=>ExpandProduct(),


     
     
     
      // Define myproducts route with proper handling for null user
      'myproducts': (context) {
        final User? user = FirebaseAuth.instance.currentUser; // Nullable type

        if (user != null) {
          // User is logged in, pass the userId
          return myproducts(userId: user.uid);
        } else {
          // User is not logged in, redirect to login
          return login();
        }
      },
    },
  ));
}
