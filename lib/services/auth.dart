import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ar/helper_functions/shared_pre_helper.dart';
import 'package:flutter_chat_ar/services/database.dart';
import 'package:flutter_chat_ar/views/home.dart';
import 'package:flutter_chat_ar/views/signin.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//
  getCurrentUser() async {
    return _auth.currentUser;
  }

// sign in function

  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
      if (userCredential != null) {
        User user = userCredential.user;

        QuerySnapshot userInfoSnapshot =
            await DatabaseMethods().getUserInfo(email);
        print(userInfoSnapshot.docs[0].data()["username"]);


        SharedPreferenceHelper()
            .saveUserName(userInfoSnapshot.docs[0].data()["username"]);
        SharedPreferenceHelper().saveUserEmail(user.email);
        SharedPreferenceHelper().saveIsLoggedIn(true);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      }
    }).catchError((error) {
      print(error);
    });
  }

// sign up function & save data to shared preference
  Future<bool> signUpWithEmailAndPassword(String username, String email,
      String password, BuildContext context) async {
    bool isSuccess = false;
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      isSuccess = true;
      User user = userCredential.user;

      SharedPreferenceHelper().saveUserName(username);
      SharedPreferenceHelper().saveUserEmail(user.email);
      SharedPreferenceHelper().saveIsLoggedIn(true);

      DatabaseMethods()
          .uploadUserInfo(user.email, username)
          .then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              )));
    }).catchError((onError) {
      print(onError);
    });

    return isSuccess;
  }

// sign out

  signOut(BuildContext context) {
    _auth.signOut();
    SharedPreferenceHelper().saveIsLoggedIn(false);
    SharedPreferenceHelper().saveUserEmail("");
    SharedPreferenceHelper().saveUserName("");

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ));
  }
}
