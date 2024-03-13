import 'package:flutter/material.dart';
import 'package:ecoupon/common_widgets/custom_alert_dialog.dart';
import 'package:ecoupon/services/auth.dart';
import 'package:ecoupon/pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecoupon/utils/firebase.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _signOut(context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final _didRequestSignOut = await CustomAlertDialog(
      title: "Déconnexion",
      content: "Êtes-vous sûr de vouloir vous déconnecter ?",
      defaultActionText: "Deconnecter",
      cancelActionText: "Annuler",
    ).show(context);

    if (_didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Widget _buildHomePageContent(UserModel user, BuildContext context) {
    return Container(
      //child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.blue[400],
                child: Text(
                  user.email.split("")[0].toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.black),
                ),
              ),
              
            ],
          ),
        ),
      //),
    );
  }

  @override
Widget build(BuildContext context) {
  final user = Provider.of<UserModel>(context, listen: false);
   final auth = Provider.of<AuthBase>(context, listen: false);
    
  return Scaffold(
    
    appBar: AppBar(
      title: Text(
        "Accueil",
        //style: TextStyle(color: Colors.black),
      ),
      //backgroundColor: Colors.blue[400],
      elevation: 1.0,
      actions: [
        PopupMenuButton<String>(
          onSelected: (String choice) {
            if (choice == 'profile') {
              // Naviguer vers la page de profil de l'utilisateur
              //auth.currentUser().then((user) {
  //if(user != null) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => Profile(profileId: user.uid)),
    );
  //} else {
    // Gérer le cas où l'utilisateur actuel n'est pas disponible
  //}
//});
            } else if (choice == 'about'){
                //Naviguer vers la page "À propos de l'application"
              Navigator.of(context).push(_AboutPage());
            } else if (choice == 'contacts') {
              // Naviguer vers la page "À propos de l'application"
              Navigator.of(context).push(_ContactPage());
            } else if (choice == 'settings') {
              // Naviguer vers la page des paramètres
            } else if (choice == 'logout') {
              _confirmSignOut(context); // Déclencher la déconnexion
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: CircleAvatar(
                    // Insérer l'image de l'utilisateur ici
                  ),
                  title: Text(user.email), // Utiliser l'email de l'utilisateur
                ),
              ),
              PopupMenuItem<String>(
                value: 'about',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('À propos'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'contacts',
                child: ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Contacts'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Paramètres'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Déconnexion'),
                ),
              ),
            ];
          },
        ),
      ],
    ),
    body: ListView(
  children: <Widget>[
    _buildAppCategory('eCeremonia', 'assets/Logo_eCeremonia.png', 'Création et réservation des salles de cérémonie en ligne', 'Télécharger', 'https://ejmia.000webhostapp.com/APKS/eCeremonia.zip'),
    
    // Ajouter d'autres applications ici
  ],
),

  );
}


Widget _buildAppCategory(String appName, String logo, String description, String buttonText, String downloadUrl) {
  return ListTile(
    leading: Image.asset(logo),
    title: Text(appName),
    subtitle: Text(description),
    trailing: ElevatedButton(
      child: Text(buttonText),
      onPressed: () {
        _launchURL(downloadUrl);
      },
    ),
  );
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Impossible de lancer $url';
  }
}



}

    
    
    
    
    
class _AboutPage extends MaterialPageRoute<void> {
  _AboutPage()
      : super(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('À propos'),
                elevation: 1.0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Développé par Emman Mlmb',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                   
                    ),
                    Image.asset('assets/ceo.jpg',
                               height: 100,
                               ),
                    SizedBox(height: 10),
                    Text(
                      'Étudiant à l\'Université de Kinshasa, Faculté des Sciences, Département de Mathématiques-Informatique',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    Text(
                      'eCoupon',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset('assets/Logo_eCoupon.png',
                               height: 100,
                               ),
                    SizedBox(height: 10),
                    Text(
                      'eCoupon est une application mobile qui permet l\'achat des coupons et recours universitair en ligne',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
}

class _ContactPage extends MaterialPageRoute<void> {
  _ContactPage()
      : super(
          builder: (BuildContext context) {
            void launchWhatsApp() async {
                final phone = '+243822128357';
                final url = "https://wa.me/$phone";
                if (await canLaunch(url)) {
                    await launch(url);
                } else {
                    throw 'Impossible de lancer $url';
                }
            }
              return Scaffold(
              appBar: AppBar(
                title: Text('Contacts'),
                elevation: 1.0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adresse :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Kinshasa, Lemba Righini'),
                    SizedBox(height: 10),
                    Text(
                      'Numéro mobile :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('+243822128357'),
                    SizedBox(height: 10),
                    Text(
                      'Email :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('emmanjibi@gmail.com'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => launchWhatsApp(),
                      child: Text('Me contacter sur WhatsApp'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
  
  
}
