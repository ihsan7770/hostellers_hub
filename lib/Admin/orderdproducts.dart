import 'package:flutter/material.dart';

class orderedproduct extends StatefulWidget {
  const orderedproduct({super.key});

  @override
  State<orderedproduct> createState() => _orderedproductState();
}

class _orderedproductState extends State<orderedproduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                  appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Orderd product",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_left), 
  onPressed: () {
 Navigator.pushNamed(context, 'admin');
  },
)

),
body: null,



    );
  }
}