




import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'spalsh.dart';
import 'Admin/admin.dart';
import 'Admin/Userdetails.dart';
import 'Admin/manageproduct.dart';
import 'Admin/orderdproducts.dart';
import 'Admin/viewfeedback.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'User/sell.dart';
import 'User/myproducts.dart';
import 'User/sendfeedback.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,   
    initialRoute: 'sendfeedback',

    
    
    
    
    
    
    routes: {
       'login':(context) =>login() ,
       'register':(context) =>register(),
         

       'splash':(context) => SplashVeiw(),
       'home':(context) => home(),
       'admin':(context)=>admin(),
       'userdetails':(context) => userdetails(),
       'manageproduct':(context) => manageproduct(),
       'orderdproducts':(context) => orderedproduct(),
       'viewfeedback':(context) => viewfeedback(),
       'sendfeedback':(context) => sendfeedback(),



       'sell':(context)=>sell(),
       'myproducts':(context) => myproducts(), 

    },



  ));
}

