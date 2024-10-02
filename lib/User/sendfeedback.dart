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
   TextEditingController _feedbackController=TextEditingController();

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
  }//ends


 Future<void> _uploadFeedback() async {
  // Check if feedback details and rating are provided
  if (_feedbackController.text.isEmpty || _selectedRating == 0) {
    print('Please provide all the required information.');
    return;
  }

  // Show the loading indicator while uploading
  setState(() {
   Future<void> _uploadFeedback() async {
  // Check if feedback details and rating are provided
  if (_feedbackController.text.isEmpty || _selectedRating == 0) {
    print('Please provide all the required information.');
    return;
  }

  // Show the loading indicator while uploading
  setState(() {
     _isUploading = true;
  });

  try {
    // Get the current authenticated user's ID
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Fetch the userName from the 'users' collection using the userId
    String? userName;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        userName = userDoc['Name'];  // Assuming 'Name' field exists in the 'users' collection
      }
    }

    if (userName == null) {
      print('User not found.');
      setState(() {
        _isUploading = false;
      });
      return;
    }

    // Collect the feedback details
    String feedback = _feedbackController.text;
    int rating = _selectedRating;  // Use _selectedRating for the rating value

    // Save feedback details to Firestore
    await FirebaseFirestore.instance.collection('feedbacks').add({
      'feedback': feedback,
      'rating': rating,  // Save the selected rating
      'userName': userName,  // Add the fetched userName
      'userId': currentUser?.uid,  // Optionally add userId as well
      'createdAt': Timestamp.now(), // Store the timestamp of feedback creation
    });

    // Print feedback details and user's name to the console
    print('Feedback: $feedback');
    print('Rating: $rating');
    print('Uploaded by User: $userName');

    // Reset the form and hide loading indicator
    setState(() {
      _isUploading = false;
      _feedbackController.clear();
      _selectedRating = 0;  // Reset the selected rating
    });
  } catch (e) {
    // Handle errors and hide loading indicator
    print('Error occurred while uploading feedback: $e');
    setState(() {
      _isUploading = false;
    });
  }
}

  });

  try {
    // Get the current authenticated user's ID
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Fetch the userName from the 'users' collection using the userId
    String? userName;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        userName = userDoc['Name'];  // Assuming 'Name' field exists in the 'users' collection
      }
    }

    if (userName == null) {
      print('User not found.');
      setState(() {
        _isUploading = false;
      });
      return;
    }

    // Collect the feedback details
    String feedback = _feedbackController.text;
    int rating = _selectedRating;  // Use _selectedRating for the rating value

    // Save feedback details to Firestore
    await FirebaseFirestore.instance.collection('feedbacks').add({
      'feedback': feedback,
      'rating': rating,  // Save the selected rating
      'userName': userName,  // Add the fetched userName
      'userId': currentUser?.uid,  // Optionally add userId as well
      'createdAt': Timestamp.now(), // Store the timestamp of feedback creation
    });

    // Print feedback details and user's name to the console
    print('Feedback: $feedback');
    print('Rating: $rating');
    print('Uploaded by User: $userName');

    // Reset the form and hide loading indicator
    setState(() {
      _isUploading = false;
      _feedbackController.clear();
      _selectedRating = 0;  // Reset the selected rating
    });
  } catch (e) {
    // Handle errors and hide loading indicator
    print('Error occurred while uploading feedback: $e');
    setState(() {
      _isUploading = false;
    });
  }
}







  @override
  Widget build(BuildContext context) {
    return Scaffold(
                 appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Send feedback",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            leading: IconButton(
            icon: Icon(Icons.arrow_left), 
            onPressed: () {
            Navigator.pushNamed(context, 'home');
  },
)

      ),
      body:    Column(
        children: [
          SizedBox(height: 10),
          Padding(
                padding:  EdgeInsets.all(8.0),
                child: Form(
                  key:  _feedkey,
                  child: TextFormField(
                    maxLines: 4,
                    controller: _feedbackController,
                    
                    
                    decoration: InputDecoration(
                      
                    
                      border: OutlineInputBorder(
                            
                            borderRadius: BorderRadius.circular(30),
                            
                      ),
                      hintText: "Feedbacks"
                      
                    ),
                    validator: (feed) {
                      if (feed == null || feed.isEmpty) {
                        return 'Please enter your feedback';
                      }}
          
                  ),
                ),
              ),
              SizedBox(height: 10),
          Text(
              'How would you rate our service?',
              style: TextStyle(fontSize: 18),
            ),

              SizedBox(height: 20),
            _buildRatingStars(),
            SizedBox(height: 32),

             ElevatedButton(
          onPressed: () {
            // Validate the form and upload feedback if valid
            if (_feedkey.currentState?.validate() == true) {
              _uploadFeedback();
            }
          },
          child: Text('Submit Feedback'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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