import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class orderedproduct extends StatefulWidget {
  const orderedproduct({super.key});

  @override
  State<orderedproduct> createState() => _orderedproductState();
}

class _orderedproductState extends State<orderedproduct> {
  Map<String, bool> soldStatus = {};

  Future<void> _notifyUser(String userId, String productName) async {
    try {
      await FirebaseFirestore.instance.collection('notifications_user').add({
        'userId': userId,
        'message': 'Your product "$productName" has been marked as sold!',
        'timestamp': Timestamp.now(),
        'isRead': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent to user.')),
      );
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send notification.')),
      );
    }
  }

  Future<void> _markAsSold(String orderId, String productId) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('deleted_products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        String userId = productDoc['userId'];
        String productName = productDoc['productName'];

        await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
          'isSold': true,
        });

        await _notifyUser(userId, productName);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product marked as sold.')),
        );

        setState(() {
          soldStatus[orderId] = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product not found.')),
        );
      }
    } catch (e) {
      print('Error marking product as sold: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark product as sold.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Ordered Products",
          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'admin');
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('orders').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final orders = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderId = order.id;

                      // Safely initialize sold status for each order, default to false if not present
                      if (!soldStatus.containsKey(orderId)) {
                        soldStatus[orderId] = (order.data() as Map<String, dynamic>).containsKey('isSold') && order['isSold'] == true;

                      }

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
                              order['productImage'],
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
                                    order['productName'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Rs${order['productPrice'].toString()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Ordered by: ${order['userName']}",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Order Date: ${DateTime.parse(order['orderDate']).toLocal().toString()}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      soldStatus[orderId] == true
                                          ? Text(
                                              "Solded",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                _markAsSold(order.id, order['productId']);
                                              },
                                              child: Text("Sold"),
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
            ),
          ],
        ),
      ),
    );
  }
}
