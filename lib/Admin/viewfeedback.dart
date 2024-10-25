import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      title: Text("Feedbacks",style:TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_back), 
  onPressed: () {
 Navigator.pushNamed(context, 'admin');
  },
)

),
body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedbacks').snapshots(),
        builder: (context, snapshot) {
          // Check if the connection is still waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Get the list of feedbacks
          final feedbacks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];

              return Card(
                
                child: ListTile(
                  title: Text(feedback['userName'],style:TextStyle(fontSize: 25,color: Colors.blue,fontWeight: FontWeight.bold)),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15,),
                      Text(feedback['feedback'],style:TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                      Text('Rating: ${feedback['rating']}',style:TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
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