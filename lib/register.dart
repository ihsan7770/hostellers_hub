import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:hostellers_hub/logics/auth_service.dart';
import 'package:hostellers_hub/logics/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  bool obs=true ;
  
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _nameController=TextEditingController();

 UsersModel _usersModel=UsersModel();
 Authentication _authentication =Authentication();

  
  final _registerkey = GlobalKey<FormState>();
  final _registerkey1 = GlobalKey<FormState>();
  final _registerkey2 = GlobalKey<FormState>();

//registration function


 void _register()async{
     
      _usersModel=UsersModel(
      Email: _emailController.text,
      Password: _passwordController.text,
      Name: _nameController.text,
      Status: 1,
      CreatedAt: DateTime.now(),
);
 
 try{ 
  await Future.delayed(Duration(seconds:1));
  
  
  final userdata= await   _authentication.registerUser(_usersModel);
    if(userdata!=null){
       Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }

 }on FirebaseAuthException catch (e){
  List err=e.toString().split("]");
  ScaffoldMessenger.of(context)
  .showSnackBar(SnackBar(content: Text(err[1])));



 }




 }


// registration function ends





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:  Colors.amber,
      title: Text("Registertion",style: TextStyle(color: Colors.white),),
      
      centerTitle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      
      
      ),
      body: SingleChildScrollView(
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
        
          Padding(
              padding:  EdgeInsets.all(8.0),
              child: Form(
                key: _registerkey,
                child: TextFormField(
                  controller: _emailController,
                  
                  
                  decoration: InputDecoration(
                  
                    border: OutlineInputBorder(
                          
                          borderRadius: BorderRadius.circular(30),
                          
                    ),
                    hintText: "Enter user email"
                  ),
                  validator: (name) => name!.length < 8 ? 'email should be least 8 character' :null,
        
                ),
              ),
            ),
        
        Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _registerkey1,
                child: TextFormField(
                   controller: _passwordController,
                  
                  decoration: InputDecoration(
                    suffixIcon:GestureDetector(onTap: (){
                    setState(() {
                        obs = !obs;
                    });
                      
                
                
                    },
                    child: Icon(obs ? Icons.visibility: Icons.visibility_off),
                    
                    ),
                    border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          
                    ),
                    hintText: "Enter your password"
                  ),
                  validator:(password) => password!.length < 8 ? 'password should be least 8 character' :null,
                 
                 obscureText: obs,
                  
                  keyboardType: TextInputType.text,
                
                  
                  
                           ),
              ),
            ),
        
        
         Padding(
              padding:  EdgeInsets.all(8.0),
              child: Form(
                key: _registerkey2,
                child: TextFormField(
                      controller: _nameController,
                  
                  
                  
                  decoration: InputDecoration(
                  
                    border: OutlineInputBorder(
                          
                          borderRadius: BorderRadius.circular(30),
                          
                    ),
                    hintText: "Enter user name"
                  ),
                  validator: (name) => name!.length < 3 ? 'Name should be least 3 character' :null,
        
                ),
              ),
            ),
        
        
        
        
        
        
        
        ElevatedButton(
             style: ButtonStyle( foregroundColor: MaterialStatePropertyAll(Colors.white),
              backgroundColor: MaterialStatePropertyAll(Colors.amber)
              ),
          
          onPressed: () async{
            if(_registerkey.currentState!.validate() &&_registerkey1.currentState!.validate() &&_registerkey2.currentState!.validate()  ){
        
        //calling register funtion
           _register();
               
               }
        
            
          
        }, child: Text("Register")),
        
        
        
        
        
        ],
        
        
        ),),
      ),
    );
  }
}