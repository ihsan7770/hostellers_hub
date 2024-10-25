import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class userdetails extends StatefulWidget {
  const userdetails({super.key});



 @override
  State<userdetails> createState() => _userdetailsState();
}

class _userdetailsState extends State<userdetails> {
   

   
   // Function to show confirmation dialog
void _showDeleteConfirmation(BuildContext context, String userId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this user?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Delete user from Firestore
                await FirebaseFirestore.instance.collection('user').doc(userId).delete();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('User deleted successfully.'),
                ));
                Navigator.of(context).pop(); // Close dialog
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: ${e.toString()}'),
                ));
              }
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}///ends deletion






  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Users",style:TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_back), 
  onPressed: () {
 Navigator.pushNamed(context, 'admin');
  },
)

),

  body: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('user').snapshots(),
  builder: (context, snapshot) {
    // Check if the connection is still waiting
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Check for errors
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    // Get the list of users
    final users = snapshot.data!.docs;

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Card(
  
  child: ListTile(
    leading: IconButton(
      onPressed: () {
        // Show confirmation dialog before deletion
        _showDeleteConfirmation(context, user.id);
      },
      icon: Icon(Icons.delete,size: 30,),
    ),
    title: Text(user['Name'],style:TextStyle(fontSize: 25,color: Colors.blue,fontWeight: FontWeight.bold)), // Display the user's name
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(user['Email'],style:TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)), // Display the user's email
        Text(user['Phone'],style:TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)), // Display the phone number, or a fallback message
      ],
    ),
  ),
);

      },
    );
  },
)









    );





    
  }
}