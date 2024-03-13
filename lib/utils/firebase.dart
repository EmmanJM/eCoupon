import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:uuid/uuid.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
//FirebaseStorage storage = FirebaseStorage.instance;
//final Uuid uuid = Uuid();

// Collection refs
CollectionReference etudiantsRef = firestore.collection('etudiants');
CollectionReference professeursRef = firestore.collection("professeurs");
CollectionReference couponsRef = firestore.collection('coupons');


// Storage refs
//Reference profilePic = storage.ref().child('profilePic');
//Reference posts = storage.ref().child('posts');
//Reference statuses = storage.ref().child('status');
