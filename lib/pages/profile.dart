import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ecoupon/common_widgets/custom_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';


    
class Profile extends StatefulWidget {
    final String profileId;
    
    Profile({required this.profileId});
    
  @override
    _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  
    final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    
  
  late String userType; // Pour stocker le type d'utilisateur après le traitement de l'email
  late String email;
  late String departement;

  @override
  void initState() {
    super.initState();
    _getUserType(); // Obtient le type d'utilisateur lors de l'initialisation de l'écran
    FirebaseFirestore.instance.collection('jurys').doc(widget.profileId).snapshots().listen((DocumentSnapshot document) {
      setState(() {
        departement = document['depts'];
      });
    });
  }
  
  Future<void> _getUserType() async {
    email = _auth.currentUser!.email!; // Obtient l'email de l'utilisateur actuel
    if (email.contains('etudiant_')) {
      userType = 'etudiants';
    } else if (email.contains('professeur_')) {
      userType = 'professeurs';
    } else if (email.contains('jury_')) {
      userType = 'jurys';
    } else {
      // Gérer d'autres types d'utilisateurs si nécessaire
      userType = 'unknown';
    }
    setState(() {});
  }
    
  _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Impossible de lancer $url';
  }
}
  
  
 Future<void> downloadAndSaveFile(String filePath) async {
  final storageRef = FirebaseStorage.instance.ref();
  final fileUrl = await storageRef
      .child(filePath)
      .getDownloadURL();

  
  try {
   
    _launchURL(fileUrl);
    // Le fichier a été téléchargé et sauvegardé localement avec succès
  } on FirebaseException catch (e) {
    CustomAlertDialog(
        title: "Erreur !",
        content: e.message!,
        defaultActionText: "OK",
      ).show(context);
    // Gérer l'erreur ici
  }
}
  
    
    
 Widget _buildInfoRow(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.grey,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}
    
Widget _buildInfoRow2(IconData icon, String title, int statut, String mention, String promotion, String semestre, String email) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.grey,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            if (statut == 1)
              TextButton.icon(
  onPressed: () async {
    String filePath = '$mention/$promotion/$semestre/$email.zip';
      
  downloadAndSaveFile(filePath);
  },
  icon: Icon(
    Icons.file_download, // Icône de téléchargement
    color: Colors.green,
  ),
  label: Text(
    'Télécharger votre coupon',
    style: TextStyle(fontSize: 14, color: Colors.green),
  ),
 )

            else
              Text(
                'Votre coupon n\'est pas encore disponible',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
          ],
        ),
      ],
    ),
  );
}

    

  Widget buildTabBarView() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: [
              Tab(text: 'L1'),
              Tab(text: 'L2'),
              Tab(text: 'L3'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Liste des étudiants de la promotion L1 du même département
                buildStudentList('MATH-INFO', 'L1'),
                // Liste des étudiants de la promotion L2 du même département
                buildStudentList('MATH-INFO', 'L2'),
                // Liste des étudiants de la promotion L3 du même département
                buildStudentList('MATH-INFO', 'L3'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStudentList(String mention, String promotion) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('etudiants').where('promotion', isEqualTo: promotion).where('mention', isEqualTo: mention).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        else if (snapshot.data!.docs.isEmpty) {
           return Text('Aucun(e) étudiant(e) trouvé');
        }else{
        /**return ListView.builder(
  padding: EdgeInsets.only(bottom: 80),
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    DocumentSnapshot document = snapshot.data!.docs[index];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Card(
        child: ListTile(
          title: Text("Email " + (document['email'] ?? "")),
          subtitle: Text("Année académique " + (document['annee_academique'] ?? "")),
        ),
      ),
    );
  },
);**/
            
        
        return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    
    Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
    String em = data['email'];
    String nom = data['nom'];
    String postnom = data['postnom'];
    String mention = data['mention'];
    String promotion = data['promotion'];
    String semestre = data['semestre'];

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.person),
          SizedBox(width: 16.0),
          Text('$nom $postnom'),
          Spacer(),
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () async {
              String storagePath = '$mention/$promotion/$semestre';
              // Insérez ici le code pour l'upload du fichier dans Firebase Storage avec le chemin storagePath
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              FirebaseFirestore.instance.collection('etudiants').doc(em).update({
                'statut': 1,
              });
            },
          ),
        ],
      ),
    );
  },
);
            
            
}      
            
                  
},
);
}
    

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection(userType).doc(widget.profileId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }else{
              Map<String, dynamic> userData = (snapshot.data!.data() as Map<String, dynamic>);


              // Afficher les informations de l'utilisateur ici, 
              return Container(
  padding: EdgeInsets.all(20.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Colors.grey[200],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage(userType == 'etudiants' ? 'assets/etudiant_image.png' : userType == 'professeurs' ? 'assets/professeur_image.png' : 'assets/jury_image.png'),
            radius: 30,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${userData['prenom']} ${userData['nom']} ${userData['postnom']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                userType == 'etudiants' ? 'Étudiant' : userType == 'professeurs' ? 'Professeur' : 'Jury',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 10),
      
      //etudiants
      if(userType == 'etudiants') _buildInfoRow(Icons.star, 'Mention', userData['mention']),
      if(userType == 'etudiants') _buildInfoRow(Icons.school, 'Promotion', userData['promotion']),
      if(userType == 'etudiants') _buildInfoRow(Icons.date_range, 'Semestre', userData['semestre']),
      if(userType == 'etudiants') _buildInfoRow2(Icons.attach_file, 'Coupon', userData['statut'], userData['mention'], userData['promotion'], userData['semestre'], userData['email']),
        
      //professeurs  
      if (userType == 'professeurs') _buildInfoRow(Icons.work, 'Départements', userData['depts']), 
      if (userType == 'professeurs') _buildInfoRow(Icons.book, 'Matières', userData['ue']),
        
      //jurys
      if (userType == 'jurys') _buildInfoRow(Icons.work, 'Départements', userData['depts']),
      if (userType == 'jurys') _buildInfoRow(Icons.date_range, 'Expérience', userData['experience']),
      if(userType == 'jurys') buildTabBarView(),
        
      
      // Ajouter d'autres champs spécifiques à l'utilisateur avec des icônes ici
    ],
  ),
);

            } 
          },
        ),
      );
    
  }
}
