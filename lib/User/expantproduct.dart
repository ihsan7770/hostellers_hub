import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added import for FirebaseAuth
import 'package:flutter/material.dart';
import 'package:hostellers_hub/logics/ordermodel.dart';

class ExpandProduct extends StatefulWidget {
  @override
  _ExpandProductState createState() => _ExpandProductState();
}

class _ExpandProductState extends State<ExpandProduct> {
  bool orderPlaced = false; // Track if order is placed
  List<DocumentSnapshot> products = [];

  // Function to create an order and store it in Firebase
  Future<OrderModel> createOrder(String productDocId, String userDocId) async {
    try {
      // Fetch product details
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productDocId)
          .get();

      // Fetch user details
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userDocId)
          .get();

      if (productSnapshot.exists && userSnapshot.exists) {
        // Extract data from snapshots
        String productId = productSnapshot.id;
        String productName = productSnapshot['productName'];
        double productPrice = productSnapshot['price'];
        String productImage = productSnapshot['imageUrl'];
        String userId = userSnapshot.id;
        String userName = userSnapshot['Name'];

        // Create an OrderModel object
        OrderModel order = OrderModel(
          orderId: FirebaseFirestore.instance.collection('orders').doc().id,
          productId: productId,
          productName: productName,
          productPrice: productPrice,
          productImage: productImage,
          userId: userId,
          userName: userName,
          orderDate: DateTime.now(),
        );

        // Store the order in Firebase (Firestore)
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(order.orderId)
            .set(order.toMap());

        return order;
      } else {
        throw Exception('Product or User not found');
      }
    } catch (e) {
      print("Error creating order: $e");
      throw Exception('Failed to create order');
    }
  }

  // Remove the product after an order is placed
  void removeProductFromList(String productId) {
    setState(() {
      products.removeWhere((product) => product.id == productId);
    });
  }

  Future<void> _placeOrder(String productDocId, BuildContext context) async {
    // Show confirmation dialog
    bool? confirm = await _showOrderConfirmationDialog(context);

    if (confirm != true) {
      return; // User canceled the order
    }

    try {
      String userDocId = FirebaseAuth.instance.currentUser!.uid;

      // Create the order
      await createOrder(productDocId, userDocId);

      // Delete the product
      await deleteProductAfterOrder(productDocId, context);

      // Remove the product from the list
      removeProductFromList(productDocId);

      // Set orderPlaced to true after successfully placing the order
      setState(() {
        orderPlaced = true;
      });
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  // Method to show confirmation dialog
  Future<bool?> _showOrderConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: const Text('Are you sure you want to place this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete product when order is placed
  Future<void> deleteProductAfterOrder(
      String productDocId, BuildContext context) async {
    try {
      // Fetch the product details from the 'products' collection
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productDocId)
          .get();

      if (productSnapshot.exists) {
        final data = productSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Move product to 'deleted_products' collection
          await FirebaseFirestore.instance
              .collection('deleted_products')
              .doc(productDocId)
              .set(data);

          // Delete the product from 'products' collection
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productDocId)
              .delete();

          _showSuccessDialog(context, 'Order placed successfully!');
        } else {
          throw Exception('No data found for the product.');
        }
      } else {
        throw Exception('Product not found.');
      }
    } catch (e) {
      print("Error deleting product after order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove product after order placement.'),
        ),
      );
    }
  }

  // Method to show success dialog
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> productDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Details",
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'home');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product image
            Image.network(
              productDetails['imageUrl'] ?? '',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // Display product name
            Text(
              productDetails['productName'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Display product price
            Text(
              'Rs${productDetails['price'].toString()}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 10),

            // Display product description
            Text(
              productDetails['description'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                orderPlaced
                    ? Text(
                        "Order Placed", // Show this text if order is placed
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          maximumSize:
                              MaterialStateProperty.all<Size>(Size(150, 50)),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(100, 40)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.amber),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _placeOrder(productDetails['productId'], context);
                        },
                        child: Text(
                          "Order",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
