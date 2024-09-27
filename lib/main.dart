




import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'spalsh.dart';
import 'Admin/admin.dart';
import 'Admin/Userdetails.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'sell.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,   
    initialRoute: 'sell',

    
    
    
    
    
    
    routes: {
       'login':(context) =>login() ,
       'register':(context) =>register(),  

      'splash':(context) => SplashVeiw(),
       'home':(context) => home(),
       'admin':(context)=>admin(),
       'userdetails':(context) => userdetails(),
       'sell':(context)=>sell()
    },



  ));
}

