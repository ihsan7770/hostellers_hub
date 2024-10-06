class OrderModel {
  final String orderId;     // Unique order ID
  final String productId;   // ID of the product
  final String productName; // Name of the product
  final double productPrice;// Price of the product
  final String productImage;// URL of the product image
  final String userId;      // ID of the user who placed the order
  final String userName;    // Name of the user who placed the order
  final DateTime orderDate; // Date and time when the order was placed

  OrderModel({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.userId,
    required this.userName,
    required this.orderDate,
  });

  // Method to convert OrderModel into a Map (for Firebase or any database)
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'userId': userId,
      'userName': userName,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  // Factory method to create OrderModel from a Map (for fetching from a database)
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: map['productPrice'] ?? 0.0,
      productImage: map['productImage'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      orderDate: DateTime.parse(map['orderDate']),
    );
  }
}
