import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:ecoupon/pages/landing_page.dart';
import 'package:ecoupon/pages/choose_page.dart';
import 'package:ecoupon/services/auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'eCoupon',
        theme: ThemeData.light(), // Utiliser un thème clair pour un arrière-plan blanc
        home: SplashScreen(), // Afficher la page SplashScreen dès le démarrage de l'application
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Utiliser un minuteur pour passer à la page suivante après quelques secondes
    Future.delayed(Duration(seconds: 3), () {
      // Naviguer vers la page LandingPage après l'affichage de l'image pendant 3 secondes
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChoosePage(),
        ),
      );
 
  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc
      body: Center(
        child: Image.asset(
          'assets/Logo_eCoupon.png', // Remplacer "your_image.gif" par le nom de votre image GIF ou PNG
          height: 200, // Hauteur souhaitée pour l'image
          width: 200, // Largeur souhaitée pour l'image
        ),
      ),
    );
  }
}
