import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashVeiw extends StatefulWidget {
  const SplashVeiw({super.key});

  @override
  State<SplashVeiw> createState() => _SplashVeiwState();
}

class _SplashVeiwState extends State<SplashVeiw> {
  String?Name;
  String?Email;
  String?Uid;
  String?Token;
  bool isLoading = true; // To track loading state



  getDate() async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
   
   Token = await _pref.getString('token');
   Email = await _pref.getString('email');
   Uid = await _pref.getString('uid');
   Name = await _pref.getString('name');
    bool isLoading = true; 

  
  
  
  }
  @override
  void initState() {
  getDate();
  //make delay for token picking
  var d = Duration(seconds: 3);
  Future.delayed(d,(){
     
     setState(() {
      isLoading = false; // Set loading to false after data is fetched
    });

     checkLoginStatous();

  });
  
    super.initState();
  }

Future<void>checkLoginStatous()async{

if(Token==null){
  Navigator.pushNamed(context, 'login');
}
else{
  Navigator.pushNamed(context, 'home');
}

}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: 180),

                  // Display image at the top
                  Image.asset("assets/host.png", height: 250, width: 300),
                  const SizedBox(height: 150), // Space between image and loading indicator
                  // Display linear progress indicator below the image
                  Container(
                    width: 360,
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(20),
                      minHeight: 7,
                       
                      
                      
                    
                    
                    
                      backgroundColor: Colors.grey[300], // Background color
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow), // Indicator color
                    ),
                  ),
                  // Space between indicator and text
                 
                ],
              )
            : Image.asset("assets/host.png", height: 250, width: 250), // Show image when not loading
      ),
    
    );
  }
}