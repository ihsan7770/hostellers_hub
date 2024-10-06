import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'logics/ordermodel.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  // TextEditingController to manage the search input
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  // Variables to store user data
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserData();

    // Listen to changes in the search input and update the query dynamically
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim(); // Update the search query
      });
    });
  }

  // Function to fetch user data
  Future<void> fetchUserData() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot users = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      setState(() {
        userName = users['Name'] ?? "No Name Found";
        userEmail = users['Email'] ?? "No Email Found"; // Fetch email
      });
    }
  }

  // Function to fetch products based on the search query
  Stream<QuerySnapshot> fetchProducts(String query) {
    if (query.isEmpty) {
      // If search query is empty, fetch all products
      return FirebaseFirestore.instance.collection('products').snapshots();
    } else {
      // If there is a search query, filter products by 'productName'
      return FirebaseFirestore.instance
          .collection('products')
          .where('productName', isGreaterThanOrEqualTo: query)
          .where('productName', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots();
    }
  }

  // Function to create an order
  Future<OrderModel> createOrder(String productDocId, String userDocId) async {
    // Fetch product details from the 'products' collection
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productDocId)
        .get();

    // Fetch user details from the 'users' collection
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userDocId)
        .get();

    if (productSnapshot.exists && userSnapshot.exists) {
      // Fetching the product details (assuming fields: name, price, image)
      String productId = productSnapshot.id;
      String productName = productSnapshot['productName'];
      double productPrice = productSnapshot['price'];
      String productImage = productSnapshot['imageUrl'];

      // Fetching the user details (assuming field: Name)
      String userId = userSnapshot.id;
      String userName = userSnapshot['Name'];

      // Create the order with all the details
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

      // Add the order to the 'orders' collection
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.orderId)
          .set(order.toMap());

      return order;
    } else {
      throw Exception('Product or User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.amber[100]),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'sell');
              },
              child: Text("Sell"),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('$userName'),
              accountEmail: Text('$userEmail'),
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
            ),
            ListTile(
              title: const Text('My products'),
              onTap: () {
                Navigator.pushNamed(context, 'myproducts');
              },
            ),
            ListTile(
              title: const Text('Send feedback'),
              onTap: () {
                Navigator.pushNamed(context, 'sendfeedback');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'login', (route) => false);
                }).catchError((error) {
                  print("Error signing out: $error");
                });
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            // Search Input Field
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Search here",
                ),
              ),
            ),

            // StreamBuilder for displaying filtered products
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchProducts(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Get the filtered list of products
                  final products = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
                              product['imageUrl'], // Replace with your image URL
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            // Text Details Section
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // Product Name
                                  Text(
                                    product['productName'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Product Price
                                  Text(
                                    "Rs${product['price'].toString()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Product Description
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            String productDocId =
                                                product.id;
                                            String userDocId =
                                                FirebaseAuth.instance
                                                    .currentUser!.uid;

                                            await createOrder(
                                                productDocId, userDocId);

                                            ScaffoldMessenger.of(
                                                    context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Order placed successfully!'),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(
                                                    context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to place order: $e'),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text("Order"),
                                      ),
                                    ],
                                  )
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
