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
          // If there's an image, you may fetch and display it in the UI
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_pnameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        (_image == null && !_isEdit)) {
      print('Please provide all required information.');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Upload image only if a new one is selected
      String? downloadUrl;
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
          if (downloadUrl != null) 'imageUrl': downloadUrl, // Update only if new image
          'updatedAt': Timestamp.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection('products').add({
          'productName': productName,
          'description': description,
          'price': price,
          'imageUrl': downloadUrl,
          'userId': currentUser?.uid,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          _isEdit ? 'Update Product' : 'Sell Product',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                    hintText: "Product Name",
                  ),
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
                    hintText: "Product Price",
                  ),
                  keyboardType: TextInputType.number,
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
                    hintText: "Product Description",
                  ),
                ),
              ),
              _image != null
                  ? Image.file(_image!, height: 150)
                  : Text(_isEdit ? 'Current image retained' : 'No image selected.'),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
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
    );
  }
}
