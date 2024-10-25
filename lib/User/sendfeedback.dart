import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class sendfeedback extends StatefulWidget {
  const sendfeedback({super.key});

  @override
  State<sendfeedback> createState() => _sendfeedbackState();
}

class _sendfeedbackState extends State<sendfeedback> {
  int _selectedRating = 0;
  TextEditingController _feedbackController = TextEditingController();
  final _feedkey = GlobalKey<FormState>();
  bool _isUploading = false;

  // Build the rating stars
  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              _selectedRating = index + 1; // Set the selected rating
            });
          },
        );
      }),
    );
  }

  // Upload feedback to Firestore
  Future<void> _uploadFeedback() async {
    if (_feedbackController.text.isEmpty || _selectedRating == 0) {
      print('Please provide all the required information.');
      return;
    }

    setState(() {
      _isUploading = true; // Show loading indicator
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Fetch the userName from the 'users' collection using the userId
      String? userName;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists) {
          userName = userDoc['Name']; // Assuming 'Name' field exists in the 'users' collection
        }
      }

      if (userName == null) {
        print('User not found.');
        setState(() {
          _isUploading = false;
        });
        return;
      }

      // Collect feedback details
      String feedback = _feedbackController.text;
      int rating = _selectedRating;

      // Save feedback to Firestore
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'feedback': feedback,
        'rating': rating,
        'userName': userName,
        'userId': currentUser?.uid,
        'createdAt': Timestamp.now(),
      });

      // Reset the form after upload
      setState(() {
        _isUploading = false;
        _feedbackController.clear();
        _selectedRating = 0;
      });

      _showSuccessDialog();

      print('Feedback uploaded by $userName: $feedback (Rating: $rating)');
    } catch (e) {
      print('Error occurred while uploading feedback: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }


  // Show a popup dialog for feedback submission success
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback Sent'),
          content: const Text('Thank you for your feedback!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          " Feedback",
          style:TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'home');
          },
        ),
      ),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _feedkey,
                    child: TextFormField(
                      maxLines: 4,
                      controller: _feedbackController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Feedbacks",
                      ),
                      validator: (feed) {
                        if (feed == null || feed.isEmpty) {
                          return 'Please enter your feedback';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'How would you rate our service?',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                _buildRatingStars(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_feedkey.currentState?.validate() == true) {
                      _uploadFeedback();
                    }
                  },
                  child: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
