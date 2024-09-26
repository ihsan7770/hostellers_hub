import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore Timestamp

class Product {
  String id;           // Firestore document ID
  String productName;  // Name of the product
  String description;  // Description of the product
  double price;        // Price of the product
  String imageUrl;     // URL of the product image
  String userName;     // Name of the user who uploaded the product
  DateTime createdAt;  // Creation timestamp

  // Constructor
  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.userName,
    required this.createdAt,
  });

  // Factory method to create a Product from a Firestore document
  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,  // Firestore document ID
      productName: data['productName'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      userName: data['userName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(), // Convert Timestamp to DateTime
    );
  }

  // Method to convert a Product to a map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'userName': userName,
      'createdAt': Timestamp.fromDate(createdAt), // Convert DateTime to Timestamp
    };
  }
}
