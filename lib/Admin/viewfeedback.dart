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
      title: Text("viewFeedbacks",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_left), 
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
                color: Colors.amber[100],
                child: ListTile(
                  title: Text(feedback['userName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Feedback: ${feedback['feedback']}'),
                      Text('Rating: ${feedback['rating']}'),
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