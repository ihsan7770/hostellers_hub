import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostellers_hub/User/sell.dart';
import 'package:hostellers_hub/logics/notification.dart';




class myproducts extends StatefulWidget {
  final String userId; // Declare userId as a required parameter

  const myproducts({Key? key, required this.userId}) : super(key: key); // Pass userId to constructor

  @override
  State<myproducts> createState() => _myproductsState();
}

class _myproductsState extends State<myproducts> {
 


  
// Utility method to fetch user details (username) from Firestore
Future<String> _getUsername(String userId) async {
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .get();
    return userSnapshot['Name'] ?? 'Unknown User';
  } catch (e) {
    print('Error fetching username: $e');
    return 'Unknown User';
  }
}

// Function to send notification to admin when a product is deleted
Future<void> _sendNotificationToAdmin(
    String productId,
    String productName,
    String description,
    double price,
    String imageUrl,
    String username) async {
  try {
    // Create a new notification using NotificationModel
    NotificationModel notification = NotificationModel(
      notificationId: FirebaseFirestore.instance.collection('notifications').doc().id, // Firestore will generate this, or you can leave it empty
      productId: productId,
      productName: productName,
      description: description,
      price: price,
      imageUrl: imageUrl,
      message: 'Product "$productName" was deleted by $username.',
      timestamp: Timestamp.now(),
    );

    // Add the notification to Firestore
    await FirebaseFirestore.instance
        .collection('notifications')
        .add(notification.toFirestore());
        
  } catch (e) {
    print('Failed to send notification: $e');
  }
}

// Method to delete a product
Future<void> _deleteProduct(BuildContext context, String productId) async {
  try {
    // Get the product to retrieve userId and product details
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    String userId = productSnapshot['userId'];
    String username = await _getUsername(userId);

    // Get product details
    String productName = productSnapshot['productName'];
    String description = productSnapshot['description'];
    double price = productSnapshot['price'];
    String imageUrl = productSnapshot['imageUrl'];

    // Delete product from Firestore
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();

    // Send notification to admin
    await _sendNotificationToAdmin(productId, productName, description, price, imageUrl, username);

    // // Show success message
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text('Product deleted successfully.'),
    // ));
  
  } 
  
  catch (e) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: ${e.toString()}'),
    ));
  }


}

// Display confirmation dialog before deleting a product
void _showDeleteProductConfirmation(BuildContext context, String productId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog immediately
              _deleteProduct(context, productId); // Perform deletion
            },
            child: const Text('Delete'),
          ),
        ],
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
          "Products",
          style:TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Use pop to return to the previous screen
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('userId', isEqualTo: widget.userId) // Use widget.userId
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final products = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

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
                            Image.network(
                              product['imageUrl'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['productName'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Rs${product['price'].toString()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    product['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                 Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: () {
            // Navigate to the sell page and pass the productId to it
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => sell(productId: product.id),
              ),
            );
          }, child: Text("Update")),

                SizedBox(
                  width: 10,
                ),
                 
                  ElevatedButton(onPressed: () {
                     _showDeleteProductConfirmation(context, product.id);


                  
                }, child: Text("Delete")),
                
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
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder for the order functionality
  void _placeOrder(String productId) {
    // Implement your order logic here
    print("Order placed for product ID: $productId");
  }
}
