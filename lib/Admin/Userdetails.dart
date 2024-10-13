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
      title: Text("Userdetails",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_left), 
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
  color: Colors.amber,
  child: ListTile(
    leading: IconButton(
      onPressed: () {
        // Show confirmation dialog before deletion
        _showDeleteConfirmation(context, user.id);
      },
      icon: Icon(Icons.delete),
    ),
    title: Text(user['Name']), // Display the user's name
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email: ${user['Email']}'), // Display the user's email
        Text('Phone: ${user['Phone'] ?? 'No phone number'}'), // Display the phone number, or a fallback message
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