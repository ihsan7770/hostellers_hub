import 'package:flutter/material.dart';
import 'dart:io'; 
import 'package:firebase_storage/firebase_storage.dart'; // Used for handling files in Dart (e.g., the image file)


import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';




class sell extends StatefulWidget {
  const sell({super.key});

  @override
  State<sell> createState() => _sellState();
}

class _sellState extends State<sell> {
  
  TextEditingController _pnameController=TextEditingController();
  TextEditingController _describtionController=TextEditingController();
  TextEditingController _priceController=TextEditingController();

  
  final _pnamekey = GlobalKey<FormState>();
  final _describtionkey = GlobalKey<FormState>();
  final _pricekey = GlobalKey<FormState>();

//image
  File? _image;  
  final ImagePicker _picker = ImagePicker();  
  bool _isUploading = false;  // end
 
 String? _userName;  // To store the user's name fetched from Firestore

 
 // Use the ImagePicker to select an image from the gallery
    Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  // If an image is selected, update the _image state variable
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);  // Convert the picked file to a File object
      });
    }
  }
 //end


// Fetch the username when the screen is initialized
   @override
  void initState() {
    super.initState();
    _fetchUserName();  
  }

  // Function to fetch the user's name from Firestore
  Future<void> _fetchUserName() async {
    try {
      // Get the current authenticated user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Fetch the user's document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(currentUser.uid)
            .get();

        // Extract the user's name from the document
        setState(() {
          _userName = userDoc['name'];  // Assume there's a 'name' field in the user's Firestore document
        });
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }

   // Function to upload the selected image and product details to Firebase Storage
 
 
  Future<void> _uploadProduct() async {
    // Check if an image and product details are provided
    if (_image == null ||
        _pnameController.text.isEmpty ||
       _describtionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _userName == null) {
      print('Please provide all the required information.');
      return;
    }

    // Show the loading indicator while uploading
    setState(() {
      _isUploading = true;
    });

    try {
      // Create a unique file name for the image based on current time
      String fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.png';

      // Reference to Firebase Storage for the image file
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      // Start the image upload
      UploadTask uploadTask = storageRef.putFile(_image!);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // After upload, get the file's download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Collect the product details
      String productName =  _pnameController.text;
      String description =_describtionController.text;
      double price = double.parse(_priceController.text);
 
 // Save product details to Firestore
      await FirebaseFirestore.instance.collection('products').add({
  'productName': productName,
  'description': description,
  'price': price,
  'imageUrl': downloadUrl,
  'userName': _userName,
  'createdAt': Timestamp.now(), // Store the timestamp of creation
});//end


      // Print product details and image URL to the console along with the user's name
      print('Product Name: $productName');
      print('Description: $description');
      print('Price: $price');
      print('Image URL: $downloadUrl');
      print('Uploaded by User: $_userName');

      // Optionally: Save product details to Firestore or any database here

      // Reset the form and hide loading indicator
      setState(() {
        _isUploading = false;
        _image = null;  // Clear the selected image
        _pnameController.clear();
       _describtionController.clear();
        _priceController.clear();
      });
    } catch (e) {
      // Handle errors and hide loading indicator
      print('Error occurred while uploading: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }


 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("sell",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            leading: IconButton(
            icon: Icon(Icons.arrow_left), 
            onPressed: () {
            Navigator.pushNamed(context, 'home');
  },
)

      ),

   body: SingleChildScrollView(
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
          Padding(
              padding:  EdgeInsets.all(8.0),
              child: Form(
                key: _pnamekey,
                child: TextFormField(
                  controller: _pnameController,
                  
                  
                  decoration: InputDecoration(
                  
                    border: OutlineInputBorder(
                          
                          borderRadius: BorderRadius.circular(30),
                          
                    ),
                    hintText: "Product name"
                  ),
                  validator: (name) => name!.length < 3 ? 'Enter a valid name' :null,
        
                ),
              ),
            ),

            
             Padding(
              padding:  EdgeInsets.all(8.0),
              child: Form(
                key: _pricekey,
                child: TextFormField(
                      controller: _priceController,
                  
                  
                  
                  decoration: InputDecoration(
                  
                    border: OutlineInputBorder(
                          
                          borderRadius: BorderRadius.circular(30),
                          
                    ),
                    hintText: "Enter product price"
                  ),
                  validator: (name) => name!.length < 1 ? 'Enter a valid price' :null,
                  keyboardType: TextInputType.number, 
        
                ),
              ),
            ),
        
        
         
          Padding(
              padding:  EdgeInsets.all(8.0),
              child: Form(
                key: _describtionkey,
                child: TextFormField(
                  controller: _describtionController,
                  
                  
                  decoration: InputDecoration(
                  
                    border: OutlineInputBorder(
                          
                          borderRadius: BorderRadius.circular(30),
                          
                    ),
                    hintText: "Enter product describtion"
                  ),
                  validator: (name) => name!.length < 5 ? 'Enter a valid describtion' :null,
        
                ),
              ),
            ),


  // Display selected image or a message if no image is selected
            _image != null
                ? Image.file(_image!, height: 150)
                : Text('No image selected.'),
            SizedBox(height: 20),

            // Button to pick an image
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
              
              // Show a loading indicator during upload, or show the upload button
            _isUploading
                    ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadProduct,
                      child: Text('Upload Products'),
                    ),
        
        
        
        
        
        ],
        
        
        ),),
      ),


    );







  }
}