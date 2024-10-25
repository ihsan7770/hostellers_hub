import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'logics/ordermodel.dart';
import 'package:badges/badges.dart' as badges;


class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _HomeState();
}

class _HomeState extends State<home> {
  // TextEditingController to manage the search input
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
 
  // List<String> deletedProductIds = []; // Ensure this is initialized

  // Variables to store user data
  String? userName;
  String? userEmail;

  // bool notificationCount =false; //badge seting

  // A list to store the current products
  List<DocumentSnapshot> products = [];

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

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot users = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();

        if (users.exists) {
          setState(() {
            userName = users['Name'] ?? "No Name Found";
            userEmail = users['Email'] ?? "No Email Found";
          });
        } else {
          setState(() {
            userName = "No Name Found";
            userEmail = "No Email Found";
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  // Function to fetch products based on the search query
  Stream<QuerySnapshot> fetchProducts(String query) {
    if (query.isEmpty) {
      return FirebaseFirestore.instance.collection('products').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('products')
          .where('productName', isGreaterThanOrEqualTo: query)
          .where('productName', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots();
    }
  }

//   // Function to create an order and store it in Firebase
// Future<OrderModel> createOrder(String productDocId, String userDocId) async {
//   try {
//     // Fetch product details
//     DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
//         .collection('products')
//         .doc(productDocId)
//         .get();

//     // Fetch user details
//     DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//         .collection('user')
//         .doc(userDocId)
//         .get();

//     // Ensure both product and user exist
//     if (productSnapshot.exists && userSnapshot.exists) {
//       // Extract data from snapshots
//       String productId = productSnapshot.id;
//       String productName = productSnapshot['productName'];
//       double productPrice = productSnapshot['price'];
//       String productImage = productSnapshot['imageUrl'];
//       String userId = userSnapshot.id;
//       String userName = userSnapshot['Name'];

//       // Create an OrderModel object
//       OrderModel order = OrderModel(
//         orderId: FirebaseFirestore.instance.collection('orders').doc().id,
//         productId: productId,
//         productName: productName,
//         productPrice: productPrice,
//         productImage: productImage,
//         userId: userId,
//         userName: userName,
//         orderDate: DateTime.now(),
//       );

//       // Store the order in Firebase (Firestore)
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(order.orderId)
//           .set(order.toMap());

//       return order;
//     } else {
//       throw Exception('Product or User not found');
//     }
//   } catch (e) {
//     print("Error creating order: $e");
//     throw Exception('Failed to create order');
//   }
// }






// // Remove the product after an order is placed
// void removeProductFromList(String productId) {
//   setState(() {
//     // Log the products before removal
//     print("Products before removal: ${products.map((p) => p.id).toList()}");
    
//     // Remove the product with the matching productId
//     products.removeWhere((product) => product.id == productId);
    
//     // Log the products after removal
//     print("Products after removal: ${products.map((p) => p.id).toList()}");
//   });
// }






  // Build method for the home screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Home", style:TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold)),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        actions: [
       

  //  StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance
  //         .collection('notifications_user')
  //         .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  //         .snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       }

  //       if (snapshot.hasError) {
  //         return IconButton(
  //           onPressed: () {},
  //           icon: Icon(Icons.notifications),
  //         );
  //       }

  //       // Update notificationCount without calling setState()
  //       var notifications = snapshot.data?.docs ?? [];
  //       var notificationCount = notifications.length;

  //       return badges.Badge(
  //         badgeContent: Text(
  //           notificationCount > 0 ? '$notificationCount' : '',
  //           style: TextStyle(color: Colors.white, fontSize: 10),
  //         ),
  //         badgeStyle: badges.BadgeStyle(
  //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //          // Only show badge if notifications exist
  //         child: IconButton(
  //           onPressed: () async {
  //             // Navigate to UserNotification and reset notification count after navigation
  //             await Navigator.pushNamed(context, 'UserNotification');
  //             setState(() {
  //              bool notificationCount = false; // Reset notification count to 0 after returning
  //             });
  //           },
  //           icon: Icon(Icons.notifications, size: 30),
  //         ),
  //         showBadge: notificationCount,
  //       );
  //     },
  //   )

  IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'UserNotification');
            },
            icon: Icon(Icons.notifications, size: 30),
          ),
      



   





        ],
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(),
      
        floatingActionButton: SizedBox(
          width: 100,
          height: 50,
          child: FloatingActionButton(
            onPressed: () {
            Navigator.pushNamed(context, 'sell');
            },
            child:  Text("Sell",style:TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold) ), // Icon inside the button
            backgroundColor: Colors.amber, // Background color of button
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position of FAB





      
    );
  }

  // Build the drawer widget
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName ?? '',style:TextStyle(fontSize: 30,fontWeight:FontWeight.bold) ,),
            accountEmail: Text(userEmail ?? '',style:TextStyle(fontSize: 17,fontWeight:FontWeight.bold)),
            decoration: BoxDecoration(color: Colors.amber),
          ),
          SizedBox(
            height: 10,
          ),
      
        ListTile(
  leading: Icon(Icons.shopping_bag), 
  title: const Text('Products'),
  onTap: () {
    Navigator.pushNamed(context, 'myproducts');
  },
),
  SizedBox(
            height: 10,
          ),



          ListTile(
            leading: Icon(Icons.feedback), 
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pushNamed(context, 'sendfeedback');
            },
            
          ),
            SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart), 
            title: const Text('My Orders'),
            onTap: () {
              Navigator.pushNamed(context, 'myorders');
            },
          ),
            SizedBox(
            height: 10,
          ),
          ListTile(

            leading: Icon(Icons.exit_to_app), 
            title: const Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  // Build the body of the screen
  Widget _buildBody() {
    return Column(
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
        
              products = snapshot.data!.docs;
        
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
        
                  return _buildProductCard(product);
                },
              );
            },
          ),
        ),
   
      
      
      ],
    );
  }

  // Build individual product card
  Widget _buildProductCard(DocumentSnapshot product) {
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
            product['imageUrl'],
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          // Text Details Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product['productName'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Product Price
                Text(
                  "Rs${product['price'].toString()}",
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
                SizedBox(height: 5),
                // Product Description
                Text(
                  product['description'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
             
    


                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () async {
                //         await _placeOrder(product.id);
                //       },
                //       child: Text("Order"),
                //     ),
                //   ],
                // ),

Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context, 
          'ExpandProduct', 
          arguments: {
            'productId': product.id,
            'productName': product['productName'],
            'price': product['price'],
            'description': product['description'],
            'imageUrl': product['imageUrl'],
          },
        );
      },
      child: Text("View"),
    ),
  ],
),


                

                
     
      




                


              ],
            ),
          ),




          
        ],
      ),
    );
  }


//  Future<void> _placeOrder(String productDocId) async {
//     // Show confirmation dialog
//   bool? confirm = await _showOrderConfirmationDialog(context);

//   if (confirm != true) {
//     return; // User canceled the order
//   }



//     try {
//       String userDocId = FirebaseAuth.instance.currentUser!.uid;

//       // Create the order
//       await createOrder(productDocId, userDocId);

//       // Delete the product
//       await deleteProductAfterOrder(productDocId);

 
//       // Remove the product from the list
//       removeProductFromList(productDocId);
//     } catch (e) {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to place order: $e')),
//       );
//     }
//   }

//   // Method to show confirmation dialog
// Future<bool?> _showOrderConfirmationDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Confirm Order'),
//         content: const Text('Are you sure you want to place this order?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false), // Cancel
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true), // Confirm
//             child: const Text('Confirm'),
//           ),
//         ],
//       );
//     },
//   );
// }//end

  
//   // Function to delete product when order is placed
// Future<void> deleteProductAfterOrder(String productDocId) async {
//   try {
//     // Fetch the product details from the 'products' collection
//     DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').doc(productDocId).get();

//     if (productSnapshot.exists) {
//       // Safely cast the data to a Map
//       final data = productSnapshot.data() as Map<String, dynamic>?;

//       if (data != null) {
//         // Move product to 'deleted_products' collection
//         await FirebaseFirestore.instance.collection('deleted_products').doc(productDocId).set(data);

//         // Delete the product from 'products' collection
//         await FirebaseFirestore.instance.collection('products').doc(productDocId).delete();

//        _showSuccessDialog(context, 'Order placed successfully!');
     
//       } else {
//         throw Exception('No data found for the product.');
//       }
//     } else {
//       throw Exception('Product not found.');
//     }
//   } catch (e) {
//     print("Error deleting product after order: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Failed to remove product after order placement.'),
//       ),
//     );
//   }
// }

// // Method to show success dialog
// void _showSuccessDialog(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Success'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(), // Close the dialog
//             child: const Text('OK'),
//           ),
//         ],
//       );
//     },
  
  
  
//   );



// }
}
