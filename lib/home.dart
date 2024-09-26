import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            title: const Text('Item 2'),
            onTap: () {},
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
      

      body: Column(children: [
        Padding(
              padding:  EdgeInsets.all(8.0),
              child: TextFormField(
              
                
                
                decoration: InputDecoration(
                
                  border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(30),
                        
                  ),
                  hintText: "Search here"
                ),
             
                      
              ),
            ),

         
        
        
         
        
        
        ]
        
        ,)
    );
  }
}