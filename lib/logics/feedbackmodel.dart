import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String userId;
  final String userName; // Fetched from 'users' collection
  final String feedback;
  final int rating;
  final DateTime timestamp;

  FeedbackModel({
    required this.userId,
    required this.userName,
    required this.feedback,
    required this.rating,
    required this.timestamp,
  });

  // Factory constructor to create a FeedbackModel from Firestore data
  factory FeedbackModel.fromFirestore(Map<String, dynamic> data, String userName) {
    return FeedbackModel(
      userId: data['userId'] as String,
      userName: userName, // Fetched separately
      feedback: data['feedback'] as String,
      rating: data['rating'] as int,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert the FeedbackModel to a map to save in Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'feedback': feedback,
      'rating': rating,
      'timestamp': timestamp,
    };
  }
}
