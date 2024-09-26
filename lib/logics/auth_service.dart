

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_model.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('user');

  // Register logic
  Future<UserCredential?> registerUser(UsersModel user) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.Email.toString(),
        password: user.Password.toString(),
      );

      if (userCredential.user != null) {
        // Ensure that fields like 'Email' and 'Name' are not null
        await _userCollection.doc(userCredential.user!.uid).set({
          'Uid': userCredential.user!.uid,
          'Email': userCredential.user!.email ?? '', // Default to empty string if null
          'Name': user.Name ?? '', // Default to empty string if null
          'CreatedAt': user.CreatedAt ?? DateTime.now(), // Default to current date if null
          'Status': user.Status ?? 'active', // Default to 'active' if null
        });

        return userCredential;
      } else {
        // If userCredential.user is null, return null
        return null;
      }
    } catch (e) {
      // Handle any errors here
      print('Error registering user: $e');
      return null;
    }
  }



//login code

Future<DocumentSnapshot?> loginUser(UsersModel user) async{
  DocumentSnapshot? snap;
 SharedPreferences _pref = await SharedPreferences.getInstance();

UserCredential userCredential= await _auth.signInWithEmailAndPassword(email: user.Email.toString(), password: user.Password.toString());
//TOKEN USED TO CHECK APP EXISTS
String? token= await userCredential.user!.getIdToken();

if(userCredential != null){
   snap= await _userCollection.doc(userCredential.user!.uid).get();

  //to stor value in token

   await _pref.setString('token', token!);
   await _pref.setString('Name', snap['Name']);
   await _pref.setString('Email', snap['Email']);
   await _pref.setString('Uid', snap['Uid']);

      return snap;}
}



 //logout
Future<void>logout()async{
  SharedPreferences _pref= await SharedPreferences.getInstance();
  await _pref.clear();
  await _auth.signOut();
}



//check logout

Future<bool>isloggedin()async{
 SharedPreferences _pref=await SharedPreferences.getInstance();
 String? _token=await _pref.getString('token');

 if(_token==null){
  return false;
 }
 else{
  return true;
 }
}





 }