import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class myproducts extends StatefulWidget {
  


  const myproducts({Key? key}) : super(key: key);

   // Method to set the userId
  void setUserId(String userId) {
    _userId = userId;
  }
  //end

  static String _userId = ''; // Static variable to hold userId

  @override
  State<myproducts> createState() => _myproductsState();
}

class _myproductsState extends State<myproducts> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Myproducts",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            leading: IconButton(
            icon: Icon(Icons.arrow_left), 
            onPressed: () {
            Navigator.pushNamed(context, 'home');
  },
)

      ),

      body:Container(
        child: Column(

          children: [

             StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: myproducts._userId) // Use static variable
          .snapshots(),
      builder: (context, snapshot) {
        // Check if the connection is still waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Get the list of products
        final products = snapshot.data!.docs;

        return Expanded(
          child: ListView.builder(
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
                    // Image Section
                    Image.network(
                      product['imageUrl'], // Replace with your image URL
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
                            product['productName'], // Replace with product name
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5), // Space between name and price
                          // Product Price
                          Text(
                            "Rs${product['price'].toString()}", // Replace with product price
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 5), // Space between price and description
                          // Product Description
                          Text(
                            product['description'], // Replace with product description
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis, // If text is too long, it will be truncated
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Implement order functionality
                                },
                                child: Text("Order"),
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
          ),
        );
      },
    )
           






          ],



        ),





      )
      
    );
  }
}



