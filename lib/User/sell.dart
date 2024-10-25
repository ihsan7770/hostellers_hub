import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class sell extends StatefulWidget {
  final String? productId;
  const sell({super.key, this.productId});

  @override
  State<sell> createState() => _sellState();
}

class _sellState extends State<sell> {
  TextEditingController _pnameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  bool _isEdit = false;
  bool _isImageSelected = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProductData();
      _isEdit = true;
    }
  }

  Future<void> _loadProductData() async {
    if (widget.productId != null) {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();
      if (productDoc.exists) {
        setState(() {
          _pnameController.text = productDoc['productName'];
          _descriptionController.text = productDoc['description'];
          _priceController.text = productDoc['price'].toString();
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isImageSelected = true;
      });
    }
  }

  Future<void> _uploadProduct() async {
  if (_formKey.currentState!.validate()) {
    if (_image == null && !_isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? downloadUrl;

      // Fetch the user's name from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .get();

      String userName = userDoc['Name']; // Assuming 'userName' field exists in 'users' collection

      // Upload image if a new one is selected
      if (_image != null) {
        String fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      }

      String productName = _pnameController.text;
      String description = _descriptionController.text;
      double price = double.parse(_priceController.text);

    if (_isEdit) {
          await FirebaseFirestore.instance
              .collection('products')
              .doc(widget.productId)
              .update({
            'productName': productName,
            'description': description,
            'price': price,
            if (downloadUrl != null) 'imageUrl': downloadUrl,
            'updatedAt': Timestamp.now(),
          });
        } else {
          // Generate a new product ID if not provided
          String newProductId = widget.productId ?? FirebaseFirestore.instance.collection('products').doc().id;
          
          await FirebaseFirestore.instance.collection('products').doc(newProductId).set({
            'productId': newProductId,
            'productName': productName,
            'description': description,
            'price': price,
            'imageUrl': downloadUrl,
            'userId': currentUser?.uid,
            'userName': userName, // Add the userName field
            'createdAt': Timestamp.now(),
          });
        }

      setState(() {
        _isUploading = false;
        _image = null;
        _pnameController.clear();
        _descriptionController.clear();
        _priceController.clear();
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error occurred while uploading: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'home');
          },
        ),
        title: Text(
          _isEdit ? 'Update Product' : 'Sell Product',
          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _pnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Name",
                    ),
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Please enter your name';
                      } else if (name.length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Price",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (price) {
                      if (price == null || price.isEmpty) {
                        return 'Please enter a price';
                      } else if (double.tryParse(price) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Description",
                    ),
                    validator: (description) {
                      if (description == null || description.isEmpty) {
                        return 'Please enter a description';
                      } else if (description.length < 10) {
                        return 'Description must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                ),
                _image != null
                    ? Image.file(_image!, height: 150)
                    : Text(_isEdit ? 'Current image retained' : 'No image selected.'),
                if (!_isImageSelected)
                  IconButton(
                    icon: Icon(
                      Icons.upload_file,
                      size: 200,
                      color: Colors.blue,
                    ),
                    onPressed: _pickImage,
                    tooltip: 'Upload Image',
                  ),
                if (_isImageSelected)
                  Text(
                    'Image selected!',
                    style: TextStyle(fontSize: 24.0, color: Colors.green),
                  ),
                _isUploading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _uploadProduct,
                        child: Text(_isEdit ? 'Update Product' : 'Sell Product'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
