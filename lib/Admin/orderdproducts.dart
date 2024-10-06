import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class orderedproduct extends StatefulWidget {
  const orderedproduct({super.key});

  @override
  State<orderedproduct> createState() => _orderedproductState();
}

class _orderedproductState extends State<orderedproduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                  appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Orderd product",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_left), 
  onPressed: () {
 Navigator.pushNamed(context, 'admin');
  },
)

),
body: Container(
  padding: EdgeInsets.all(10),
  child: Column(
    children: [
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders') // Use 'orders' collection
              .snapshots(),
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
                        order['productImage'], // Display product image from order
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
                              order['productName'], // Display product name
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Rs${order['productPrice'].toString()}", // Display product price
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Ordered by: ${order['userName']}", // Display user name
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Order Date: ${DateTime.parse(order['orderDate']).toLocal().toString()}", // Display order date
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
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
)




    );
  }
}