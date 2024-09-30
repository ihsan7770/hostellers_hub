import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

//name show function
 String? userName;
String? userEmail;

@override
void initState() {
  super.initState();
  fetchUserData();
}

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
      userEmail = users['Email'] ?? "No Email Found";  // Fetch email
    });
  }
}


//ends



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Home",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
       actions: [
          
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.amber[100])
            
            
            ),
            onPressed:  () {
              Navigator.pushNamed(context, 'sell');
            }, child: Text("Sell")),
        ),
      ]
      ),
      drawer:Drawer(
        backgroundColor:Colors.amber,
        child: ListView(
          
          children: [
            UserAccountsDrawerHeader(
            accountName: Text('$userName'), 
            accountEmail: Text('$userEmail'),
            decoration: BoxDecoration(
            color: Colors.blue, 
            ),
            ),
            
             ListTile(
            title: const Text('My products'),
            onTap: () {
               Navigator.pushNamed(context, 'home');

              
            },
            ),

             ListTile(
        title: const Text('Logout'),
        onTap: () {
                      FirebaseAuth.instance.signOut().then((value) {
  // Ensure the user is not null before accessing the email
  var user = FirebaseAuth.instance.currentUser;
  
  if (user != null) {
    print(user.email);
  }
  
  // Navigate to 'home' and remove all previous routes
  Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
}).catchError((error) {
  // Handle errors if needed
  print("Error signing out: $error");
}


);



        },
      ),
         
         
         
         
          ],
        ),
        

       
        
        
        
        
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
              product['description'],  // Replace with product description
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
                  
                }, child: Text("Order")),
              ],
            )


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