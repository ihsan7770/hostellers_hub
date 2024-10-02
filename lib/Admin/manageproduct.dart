import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class manageproduct extends StatefulWidget {
  const manageproduct({super.key});

  @override
  State<manageproduct> createState() => _manageproductState();
}

class _manageproductState extends State<manageproduct> {



  // Function to show confirmation dialog for deleting a product
void _showDeleteProductConfirmation(BuildContext context, String productId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this product?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Delete product from Firestore
                await FirebaseFirestore.instance.collection('products').doc(productId).delete();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Product deleted successfully.'),
                ));
                Navigator.of(context).pop(); // Close dialog
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: ${e.toString()}'),
                ));
              }
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
//function ends
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Manage product",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: IconButton(
  icon: Icon(Icons.arrow_left), 
  onPressed: () {
 Navigator.pushNamed(context, 'admin');
  },
)

),

 body:Container(
        child:Column 
          (children: [
            Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: TextFormField(
                  
                    
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                     
                    
                      border: OutlineInputBorder(
                        
                            
                            borderRadius: BorderRadius.circular(30),
                          
                            
                      ),
                      hintText: "Search here",
                      
          
                      
                    ),
                 
                          
                  ),
                ),


  Expanded(
    child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
              product['productName'],  // Replace with product name
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),  // Space between name and priceS
            // Product Price
            Text(
              "Rs${product['price'].toString()}",  // Replace with product price
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 5),  // Space between price and description
            // Product Description
            Text(
            " Own by ${ product['userName']}",  // Replace with product description
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,  // If text is too long, it will be truncated
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: () {
                  
                }, child: Text("Sold")),

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
        }
      );
    },
    ),
  )


               
                    
             
                
                
                
                
                
                
                ],
                    
                
          
              
                
          
              
          
          
          
                ),
        
      )



    );
  }
}