import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future<bool> signIn({
  required String email,
  required String password,
}) async {
  bool sign = false;
  try {
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) {
      if (value.user != null) {
        sign = true;
      }
    });
  } on FirebaseAuthException catch (authenticationError) {
    switch (authenticationError.code) {
      case "user-not-found":
        Fluttertoast.showToast(
          msg: "E-mail address is not attached to any account.",
          toastLength: Toast.LENGTH_LONG,
        );
        break;
      case "wrong-password":
        Fluttertoast.showToast(
          msg: "Password you provided is wrong.",
          toastLength: Toast.LENGTH_LONG,
        );
        break;
      case "invalid-email":
        Fluttertoast.showToast(
          msg: "E-mail you provided is not valid.",
          toastLength: Toast.LENGTH_LONG,
        );
        break;
      case "user-disabled":
        Fluttertoast.showToast(
          msg: "This account has been disabled. Please contact us: javinsensestudios@gmail.com",
          toastLength: Toast.LENGTH_LONG,
        );
        break;
    }
  }

  return sign;
}

Future<bool> signup({
  required String name,
  required String email,
  required String password,
  required String phoneNumber,
  String? companyName,
}) async {
  bool sign = false;

  try {
    bool userCreation = false;
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      if (value.user != null) {
        userCreation = true;
      }
    });
    if (userCreation) {
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
        "userName": name,
        "userEmail": email,
        "userCompanyName": companyName,
        "userJoinTime": DateTime.now(),
        "userPhoneNumber": phoneNumber,
        "userUID": FirebaseAuth.instance.currentUser!.uid,
      }).then((value) {
        sign = true;
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_LONG,
        );
      });
    }
  } on FirebaseAuthException catch (authenticationError) {
    switch (authenticationError.code) {
      case "email-already-in-use":
        Fluttertoast.showToast(
          msg: "This e-mail address in already in use.",
          toastLength: Toast.LENGTH_LONG,
        );
        break;
      case "weak-password":
        Fluttertoast.showToast(
          msg: "Password you provided is not strong enough.",
          toastLength: Toast.LENGTH_LONG,
        );
        break;
      case "invalid-email":
        Fluttertoast.showToast(
          msg: "E-mail you provided is not valid.",
          toastLength: Toast.LENGTH_LONG,
        );
        break;
      case "operation-not-allowed":
        Fluttertoast.showToast(
          msg: "E-mail/Password sign method are closed. Please contact us: javinsensestudios@gmail.com",
          toastLength: Toast.LENGTH_LONG,
        );
        break;
    }
  }
  return sign;
}

Future<bool> signOut() async {
  bool signOut = false;

  try {
    await FirebaseAuth.instance.signOut().then((value) {
      signOut = true;
    });
  } catch (error) {
    Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  return signOut;
}
