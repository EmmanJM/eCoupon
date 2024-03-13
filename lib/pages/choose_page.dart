import 'package:flutter/material.dart';
import 'package:ecoupon/pages/home_page.dart';
import 'package:ecoupon/pages/sign_in_page.dart';
import 'package:ecoupon/pages/landing_page.dart';
import 'package:ecoupon/services/auth.dart';
import 'package:provider/provider.dart';

class ChoosePage extends StatefulWidget {
  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0; // Variable pour stocker l'index de l'onglet sélectionné

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index; // Mettre à jour la valeur de l'index lorsque l'onglet est changé
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
    
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<UserModel?>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        UserModel? user = snapshot.data;
        if (user == null) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 200, // Taille du conteneur pour le logo et le texte initial
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/Logo_eCoupon.png', // Logo de l'application
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Êtes-vous un étudiant, professeur ou jury ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Veuillez choisir et cliquer sur "Suivant"',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'Étudiant'),
                      Tab(text: 'Professeur'),
                      Tab(text: 'Jury'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Center(child: Image.asset('assets/etudiant_image.png', height: 150, width: 150)), // Image étudiant
                        Center(child: Image.asset('assets/professeur_image.png', height: 150, width: 150)), // Image professeur
                        Center(child: Image.asset('assets/jury_image.png', height: 150, width: 150)), // Image jury
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Définir le rayon pour faire une ellipse
                          ),
                        ),
                      ),
                      onPressed: () {
                        //String userType;
                        // Logique pour passer à la page suivante en fonction de l'option sélectionnée
                        
if (selectedTabIndex == 0) {
  //userType = 'etudiant_';
    Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage(userType:'etudiant_')));
} else if (selectedTabIndex == 1) {
  //userType = 'professeur_';
    Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage(userType:'professeur_')));
} else if (selectedTabIndex == 2) {
  //userType = 'jury_';
    Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage(userType:'jury_')));
} else {
  //userType = '';
}

                        
                        
                      },
                      child: Text('Suivant'),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Provider<UserModel>.value(value: user, child: HomePage());
        }
      },
    );
  }
}