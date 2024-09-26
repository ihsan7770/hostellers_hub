import 'package:flutter/material.dart';
import 'package:hostellers_hub/logics/auth_service.dart';
import 'package:hostellers_hub/logics/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();

  final String _adminEmail = 'admin@gmail.com';
  final String _adminPassword = 'admin1234';


  final _logkey = GlobalKey<FormState>();
  final _logkey1 = GlobalKey<FormState>();


  bool obs=true ;

  UsersModel _usersModel=UsersModel();
  Authentication _authentication =Authentication();

//login function ends
  
  void _login()async{
  try{
    _usersModel=UsersModel(
      Email: _emailController.text,
      Password: _passwordController.text,
      );
    
    final data = await _authentication.loginUser(_usersModel);
     if(data!=null){
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
     }

  }on FirebaseAuthException catch (e){
  List err=e.toString().split("]");
  ScaffoldMessenger.of(context)
  .showSnackBar(SnackBar(content: Text(err[1])));
}  }

//login function ends




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(backgroundColor:  Colors.amber,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
     
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.amber[100])
            
            
            ),
            onPressed:  () {
                Navigator.pushNamed(context, "register");
          
                }, child: Text("Sign in")),
        )]
      
      
      
      ),
      
      body: Center(
       
        child: 
        
        SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          
          children: [

           
         
          SizedBox(
            width: 50,
            height: 50,
          ),
          
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Form(
              key:  _logkey,
              child: TextFormField(
                controller: _emailController,
                
                
                decoration: InputDecoration(
                
                  border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(30),
                        
                  ),
                  hintText: "Enter user email"
                ),
                validator: (name) => name!.length < 6 ? 'email should be least 7 character' :null,

              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key:  _logkey1,
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
                validator:(password) => password!.length < 8 ? 'password ' :null,
               
               obscureText: obs,
                
                keyboardType: TextInputType.text,
              
                
                
                         ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
          ),
          ElevatedButton(
            
            style: ButtonStyle( foregroundColor: MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(Colors.amber)
            ),
          
            onPressed: () async{
              if( _logkey.currentState!.validate() && _logkey1.currentState!.validate() ){

                   if (_emailController.text == _adminEmail &&
            _passwordController.text == _adminPassword) {
          // If credentials match, navigate to admin dashboard
          Navigator.pushReplacementNamed(context, 'admin');
        } else {
          _login();
         
        }

                



             
            
        
              }
        
          }, child: Text("login")),
          
          SizedBox(
            width: 150,
            height: 150,
          ),
       
          
          ],
          
          
          
                ),
        ),//column
      
      ),//center
   
   
   
   
   
    );//scaf
  }
}