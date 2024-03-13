import 'package:flutter/material.dart';
import 'package:ecoupon/pages/sign_in/email_sign_in_model.dart';
import 'package:ecoupon/pages/sign_in/email_sign_in_form.dart';
import 'package:ecoupon/services/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final String userType; // Ajout d'une variable pour stocker la valeur à envoyer

  
  SignInPage({required this.userType});
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: EmailSignInForm.create(context, userType), // Utilisation de EmailSignInForm.create avec la valeur en paramètre
    );
  }
}