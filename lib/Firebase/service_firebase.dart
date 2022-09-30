import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_push_notification/models/customer.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ServiceFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // SignIn
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email");
      } else if(e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password");
      }
    }
  }

  // Sign Up
  Future<void> signUp(String username, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = _firebaseAuth.currentUser;
      final token = await FirebaseMessaging.instance.getToken();
      await _firebaseFirestore.collection('users').doc(user?.uid).set({
        'id' : user?.uid,
        'username' : username,
        'email' : email,
        'token' : token,
      });
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


}