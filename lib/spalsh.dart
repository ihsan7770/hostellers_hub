import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashVeiw extends StatefulWidget {
  const SplashVeiw({super.key});

  @override
  State<SplashVeiw> createState() => _SplashVeiwState();
}

class _SplashVeiwState extends State<SplashVeiw> {
  String?Name;
  String?Email;
  String?Uid;
  String?Token;
  getDate() async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
   
   Token = await _pref.getString('token');
   Email = await _pref.getString('email');
   Uid = await _pref.getString('uid');
   Name = await _pref.getString('name');

  
  
  
  }
  @override
  void initState() {
  getDate();
  //make delay for token picking
  var d = Duration(seconds: 2);
  Future.delayed(d,(){
     checkLoginStatous();

  });
  
    super.initState();
  }

Future<void>checkLoginStatous()async{

if(Token==null){
  Navigator.pushNamed(context, 'login');
}
else{
  Navigator.pushNamed(context, 'home');
}

}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body:Center(
        child: Text("HOSTELLERS HUB"),
      )
    );
  }
}