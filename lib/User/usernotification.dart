import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({super.key});

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  // Get the current user's ID
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  // Function to delete a notification
  Future<void> _deleteNotification(String docId) async {
    await FirebaseFirestore.instance
        .collection('notifications_user')
        .doc(docId)
        .delete();
  }

  // StreamBuilder to listen to the notifications collection
  Widget _buildNotificationsStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications_user')
          .where('userId', isEqualTo: userId) // Filter by user ID
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final notifications = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final docId = notification.id;

            return Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          notification['message'], // Display the corresponding message
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, ),
                    onPressed: () async {
                      // Show confirmation dialog before deleting
                      final confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete Notification"),
                          content: Text("Are you sure you want to delete this notification?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      // If confirmed, delete the notification
                      if (confirmDelete == true) {
                        _deleteNotification(docId);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'home');
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: _buildNotificationsStream(), // Use the StreamBuilder method here
      ),
    );
  }
}
