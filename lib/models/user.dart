import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel2 {
  String? nom;
  String? postnom;
  String? prenom;
  String? sexe;
  String? mention;
  String? promotion;
  String? annee_academique;
  String? email;
  String? tel;
  String? id;
  Timestamp? signedUpAt;
  Timestamp? lastSeen;
  bool? isOnline;

  UserModel2(
      {this.nom,
      this.postnom,
      this.prenom,
      this.sexe,
      this.promotion,
      this.mention,
      this.annee_academique,
      this.email,
      this.tel,
      this.id,
      this.signedUpAt,
      this.isOnline,
      this.lastSeen,
      });

  UserModel2.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    postnom = json['postnom'];
    prenom = json['prenom'];
    sexe = json['sexe'];
    promotion = json['promotion'];
    mention = json['mention'];
    annee_academique = json['annee_academique'];
    email = json['email'];
    tel = json['tel'];
    signedUpAt = json['signedUpAt'];
    isOnline = json['isOnline'];
    lastSeen = json['lastSeen'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nom'] = this.nom;
    data['postnom'] = this.postnom;
    data['prenom'] = this.prenom;
    data['sexe'] = this.sexe;
    data['promotion'] = this.promotion;
    data['mention'] = this.mention;
    data['annee_academique'] = this.annee_academique;
    data['email'] = this.email;
    data['tel'] = this.tel;
    data['signedUpAt'] = this.signedUpAt;
    data['isOnline'] = this.isOnline;
    data['lastSeen'] = this.lastSeen;
    data['id'] = this.id;
    return data;
  }
}
