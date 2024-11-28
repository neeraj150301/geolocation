import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  // fireAuth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // get current user
  User? currentUser() => _firebaseAuth.currentUser;

  // Sign In
  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      // login
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // save user to firestore if does'nt exist
      await _fireStore.collection('Users').doc(result.user!.uid).set(
        {
          'uid': result.user!.uid,
          'email': email,
          'fcmToken': fcmToken,
        },
        SetOptions(merge: true), // Merge fields instead of overwriting
      );

      return result;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'The password is incorrect.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
            child: Text(
              'Login Failed',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Sign Out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Sign Up
  Future signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      // create user
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // save user to firestore
      await _fireStore.collection('Users').doc(result.user!.uid).set(
        {
          'uid': result.user!.uid,
          'email': email,
          // 'name': '',
          'fcmToken': fcmToken,
        },
      );
      return result;
    } on FirebaseAuthException catch (e) {
      // print(e);
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'Entered email is already registered with us.\nPlease try with another email or login.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 10),
              Text(errorMessage),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
