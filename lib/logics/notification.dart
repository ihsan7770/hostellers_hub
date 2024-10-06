import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;  // Added notificationId
  final String productId;
  final String productName;
  final String description;
  final double price;
  final String imageUrl;
  final String message;
  final Timestamp timestamp;

  NotificationModel({
    required this.notificationId,  // Added to constructor
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.message,
    required this.timestamp,
  });

  // Factory constructor to create a NotificationModel from a Firestore document
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      notificationId: data['notificationId'] ?? '',  // Use the document ID as the notificationId
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert NotificationModel instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'notificationId': notificationId,
      'productId': productId,
      'productName': productName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'message': message,
      'timestamp': timestamp,
    };
  }

  // Convert NotificationModel instance to a JSON-like map (if needed for other purposes)
  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,  // Include the notificationId in the JSON
      'productId': productId,
      'productName': productName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'message': message,
      'timestamp': timestamp.toDate().toString(),
    };
  }
}
