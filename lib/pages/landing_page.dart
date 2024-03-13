import 'package:flutter/material.dart';
import 'package:ecoupon/pages/home_page.dart';
import 'package:ecoupon/pages/sign_in_page.dart';
import 'package:ecoupon/services/auth.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {

  final String userType;
    
  LandingPage({required this.userType});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
      
    return StreamBuilder<UserModel?>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserModel? user = snapshot.data;
          if (user == null) {
            return SignInPage(userType: widget.userType); // Envoi de selectedOption à la page SignInPage
              
              
          }
          return Provider<UserModel>.value(value: user, child: HomePage());
        }else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
       
      },
    );
  }
}