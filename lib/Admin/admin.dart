import 'package:flutter/material.dart';

class admin extends StatefulWidget {
  const admin({super.key});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Admin",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_left), 
  onPressed: () {
  Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  },
)),

body: Column(children: [
  SizedBox(
    height: 20,
    width: 20,
  ),

InkWell(
  onTap: () {
     Navigator.pushNamed(context, 'userdetails');
  },
  
  child: Container(
    color: Colors.amber,
    width: 250,
    height: 80,
    child: Center(child: Text("Manage User", style: TextStyle(color: Colors.white,fontSize: 20),      )),
    ),
    
),
    SizedBox(
    height: 20,
    width: 20,
  ),
  Container(
  color: Colors.amber,
  width: 250,
  height: 80,
  child: Center(child: Text("Manage product", style: TextStyle(color: Colors.white,fontSize: 20),      )),
  )

  




],),




    );
  }
}