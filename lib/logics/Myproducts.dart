import 'package:flutter/material.dart';

class myproducts extends StatefulWidget {
  const myproducts({super.key});

  @override
  State<myproducts> createState() => _myproductsState();
}

class _myproductsState extends State<myproducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(        appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Myproducts",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            leading: IconButton(
            icon: Icon(Icons.arrow_left), 
            onPressed: () {
            Navigator.pushNamed(context, 'home');
  },
)

      ),




    );
  }
}