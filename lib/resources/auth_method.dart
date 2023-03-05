import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occured";
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photoUrl =
          await StorageMethods().uploadImage('profilepics', file, false);

      model.User user = model.User(
          bio: bio,
          email: email,
          followers: [],
          following: [],
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          username: username);
      await firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());
      res = 'success';
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "The email address is badly formatted.";
      } else if (err.code == 'email-already-in-use') {
        res = 'The email address is already in use by another account.';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 character';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
