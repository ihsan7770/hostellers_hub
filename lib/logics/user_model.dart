import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  String? Email;
  String? Password;
  String? Name;
  DateTime? CreatedAt;
  int? Status;
  String? Uid;

  UsersModel({
    this.Email,
    this.Password,
    this.Name,
    this.CreatedAt,
    this.Status,
    this.Uid,
  });

  // Factory constructor to create a UsersModel from a DocumentSnapshot
  factory UsersModel.fromJson(DocumentSnapshot<Map<String, dynamic>> data) {
    final json = data.data()!;
    return UsersModel(
      Email: json['Email'] as String?,
      Uid: json['Uid'] as String?,
      Name: json['Name'] as String?,
      Status: json['Status'] as int?,
      CreatedAt: (json['CreatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Method to convert UsersModel to JSON for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      "Uid": Uid,
      "Name": Name,
      "Email": Email,
      "Password": Password,
      "Status": Status,
      "CreatedAt": CreatedAt != null ? Timestamp.fromDate(CreatedAt!) : null,
    };
  }
}
