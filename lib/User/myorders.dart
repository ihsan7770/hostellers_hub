import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class myorders extends StatefulWidget {
  const myorders({super.key});

  @override
  State<myorders> createState() => _myordersState();
}

class _myordersState extends State<myorders> {
  List<String> deletedProductIds = [];

  // Get the current logged-in user's ID
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Stream to fetch orders for the current user
  Stream<QuerySnapshot> _fetchUserOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

Future<void> cancelOrderAndRestoreProduct(String orderId, String productDocId) async {
  try {
    // Delete the order from Firestore
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();

    // Fetch the product from the 'deleted_products' collection
    DocumentSnapshot deletedProductSnapshot = await FirebaseFirestore.instance
        .collection('deleted_products')
        .doc(productDocId)
        .get();

    if (deletedProductSnapshot.exists) {
      // Retrieve the data and cast it to a Map<String, dynamic>
      final productData = deletedProductSnapshot.data() as Map<String, dynamic>?;

      if (productData != null) {
        // Restore product back to 'products' collection
        await FirebaseFirestore.instance.collection('products').doc(productDocId).set(productData);

        // Delete from 'deleted_products' collection after restoration
        await FirebaseFirestore.instance.collection('deleted_products').doc(productDocId).delete();

        // Check if the widget is still mounted before using context
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order canceled and product restored successfully.'),
            ),
          );
        }
      } else {
        throw Exception('No data found for the deleted product.');
      }
    } else {
      throw Exception('Deleted product not found.');
    }
  } catch (e) {
    print("Error: $e");

    // Check if the widget is still mounted before showing an error message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel the order and restore the product.'),
        ),
      );
    }
  }
}



  // Function to show a confirmation dialog before canceling the order
  void _showCancelOrderConfirmation(BuildContext context, String orderId, String productDocId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Cancellation'),
          content: const Text('Are you sure you want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                cancelOrderAndRestoreProduct(orderId, productDocId); // Perform the cancellation
              },
              child: const Text('Yes'),
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
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Use pop to return to the previous screen
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Check if there are no orders
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No orders found!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          // Display orders in a ListView
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              // Extracting order details
              String productName = order['productName'];
              double productPrice = order['productPrice'];
              String productImage = order['productImage'];
              String productDocId = order['productId']; // Assuming you have the product ID stored in the order

              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Image.network(
                      productImage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Product Price
                          Text(
                            "Rs${productPrice.toString()}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () {
                              _showCancelOrderConfirmation(context, order.id, productDocId);
                            },
                            child: const Text("Cancel Order"),
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
