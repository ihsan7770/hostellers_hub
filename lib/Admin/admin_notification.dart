import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNoti extends StatefulWidget {
  const AdminNoti({super.key});

  @override
  State<AdminNoti> createState() => _AdminNotiState();
}

class _AdminNotiState extends State<AdminNoti> {

void _showDeleteNotificationConfirmation(BuildContext context, String notificationId) {
  // Store a persistent reference to the current context
  final scaffoldContext = context;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this notification?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Close the dialog first
              Navigator.of(dialogContext).pop();

              try {
                // Perform deletion
                await FirebaseFirestore.instance
                    .collection('notifications')
                    .doc(notificationId)
                    .delete();

                // Check if the widget is still mounted before using context
                if (mounted) {
                  // Use the persistent scaffoldContext
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(
                    content: Text('Notification deleted successfully.'),
                  ));
                }
              } catch (e) {
                // Ensure the widget is still mounted before using context
                if (mounted) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(
                    content: Text('Error: ${e.toString()}'),
                  ));
                }
              }
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}







  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("admin notifications",style: TextStyle(color: Colors.white),),
      
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
          stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final notifications = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                // Extracting notification details
                String productId = notification['productId'];
                String productName = notification['productName'];
                String notificationId =  notification['notificationId'];
                // String description = notification['description'];
                double price = notification['price'];
                String imageUrl = notification['imageUrl'];
                String message = notification['message'];
                Timestamp timestamp = notification['timestamp'];

                // // Format timestamp
                // String formattedDate = DateFormat.yMMMd().add_jm().format(timestamp.toDate());

                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      Image.network(
                        imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10), // Space between image and text

                      // Text Details Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              productName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5), // Space between name and price

                            // Product Price
                            Text(
                              "Rs $price",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 5), // Space between price and description

                            // // Product Description
                            // Text(
                            //   description,
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     color: Colors.grey[700],
                            //   ),
                            //   maxLines: 3,
                            //   overflow: TextOverflow.ellipsis, // If text is too long, it will be truncated
                            // ),
                            // SizedBox(height: 5),

                            // Notification Message
                            Text(
                              message,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),

                            // // Timestamp
                            // Text(
                            //   'Sent: $formattedDate',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.grey[600],
                            //   ),
                            // ),
                          
                                       Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               

                SizedBox(
                  width: 10,
                ),

                IconButton(
  iconSize: 30,
  icon: const Icon(Icons.delete),
  onPressed: () {
     _showDeleteNotificationConfirmation(context,notificationId);
    // ...
  },
),
                 
              
                
              
              
              
              ],
            
            
            
            ),
                          
                          
                          
                          
                          ],
                        ),
                      ),
                    ],


                  ),
                );
              },
            );
          },
        ),




    );
  }
}