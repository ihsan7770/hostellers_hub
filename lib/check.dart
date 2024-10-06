// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'notification_model.dart'; // Import your NotificationModel class

// // Utility method to fetch user details (username) from Firestore
// Future<String> _getUsername(String userId) async {
//   try {
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//         .collection('user')
//         .doc(userId)
//         .get();
//     return userSnapshot['Name'] ?? 'Unknown User';
//   } catch (e) {
//     print('Error fetching username: $e');
//     return 'Unknown User';
//   }
// }

// // Function to send notification to admin when a product is deleted
// Future<void> _sendNotificationToAdmin(
//     String productId,
//     String productName,
//     String description,
//     double price,
//     String imageUrl,
//     String username) async {
//   try {
//     // Create a new notification using NotificationModel
//     NotificationModel notification = NotificationModel(
//       notificationId: '', // Firestore will generate this, or retrieve if you have the ID
//       productId: productId,
//       productName: productName,
//       description: description,
//       price: price,
//       imageUrl: imageUrl,
//       message: 'Product "$productName" was deleted by $username.',
//       timestamp: Timestamp.now(),
//     );

//     // Add the notification to Firestore
//     await FirebaseFirestore.instance
//         .collection('notifications')
//         .add(notification.toFirestore());

//   } catch (e) {
//     print('Failed to send notification: $e');
//   }
// }

// // Method to delete a product
// Future<void> _deleteProduct(BuildContext context, String productId) async {
//   try {
//     // Get the product to retrieve userId and product details
//     DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
//         .collection('products')
//         .doc(productId)
//         .get();
    
//     String userId = productSnapshot['userId'];
//     String username = await _getUsername(userId);
    
//     // Get product details
//     String productName = productSnapshot['productName'];
//     String description = productSnapshot['description'];
//     double price = productSnapshot['price'];
//     String imageUrl = productSnapshot['imageUrl'];

//     // Delete product from Firestore
//     await FirebaseFirestore.instance
//         .collection('products')
//         .doc(productId)
//         .delete();

//     // Send notification to admin
//     await _sendNotificationToAdmin(productId, productName, description, price, imageUrl, username);

//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Product deleted successfully.'),
//     ));
//   } catch (e) {
//     // Show error message
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Error: ${e.toString()}'),
//     ));
//   }
// }

// // Display confirmation dialog before deleting a product
// void _showDeleteProductConfirmation(BuildContext context, String productId) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Confirm Deletion'),
//         content: const Text('Are you sure you want to delete this product?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close dialog immediately
//               _deleteProduct(context, productId);   // Perform deletion
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       );
//     },
//   );
// }
