import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intellistudy/providers/providers.dart';

class AuthenticationModel {
  const AuthenticationModel(this._auth, this.ref, this._firestore);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Ref ref;

  //  This getter will be returning a Stream of User object.
  //  It will be used to check if the user is logged in or not.
  Stream<User?> get authStateChange => _auth.idTokenChanges();
  //  This getter will be returning the firebase auth instance
  FirebaseAuth get auth => _auth;

  // Now This Class Contains 3 Functions currently
  // 1. signInWithGoogle
  // 2. signOut
  // 3. signInwithEmailAndPassword

  //  SignIn the user using Email and Password
  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      ref.read(emailTextProvider).clear();
      ref.read(passwordTextProvider).clear();
    } on FirebaseAuthException catch (e) {
      ref.read(passwordTextProvider).clear();
      ref.read(firstIsLoadingStateProvider.notifier).state = false;
      // Alert dialog that displays the error with an OK button to dismiss it
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      // Catches error if the email is already in use or if there is an error
      print('Error at login: $e');
    }
  }

  // SignUp the user using Email and Password
  Future<void> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid.toString())
          .collection('flashcardSets')
          .doc()
          .set({});

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid.toString())
          .set({
        'username': email.substring(0, email.indexOf('@')),
        'email': email.trim(),
        'image_url': '',
        'userId': _auth.currentUser!.uid.toString(),
      });

      ref.read(emailTextProvider).clear();
      ref.read(passwordTextProvider).clear();
    } on FirebaseAuthException catch (e) {
      ref.read(firstIsLoadingStateProvider.notifier).state = false;
      ref.read(passwordTextProvider).clear();

      // Alert dialog that displays the error with an OK button to dismiss it
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text('Error Occured'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    )
                  ]));
    } catch (e) {
      // Catches error if the email is already in use or if there is an error
      if (e == 'email-already-in-use') {
        print('Email already in use.');
      } else {
        print('Error at signup: $e');
      }
    }
  }

  //  SignIn the user Google
  Future<void> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"))
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  //  SignOut the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
