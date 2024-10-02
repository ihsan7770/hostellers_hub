import 'package:flutter/material.dart';

class viewfeedback extends StatefulWidget {
  const viewfeedback({super.key});

  @override
  State<viewfeedback> createState() => _viewfeedbackState();
}

class _viewfeedbackState extends State<viewfeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(                
       appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Feedbacks",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_left), 
  onPressed: () {
 Navigator.pushNamed(context, 'admin');
  },
)

),



     );
  }
}

                //appBar: AppBar(backgroundColor:  Colors.amber,
//       title: Text("Feedbacks",style: TextStyle(color: Colors.white),),
      
//       centerTitle: true,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//       leading: IconButton(
//   icon: Icon(Icons.arrow_left), 
//   onPressed: () {
//  Navigator.pushNamed(context, 'admin');
//   },
// )

// ),