import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String userName, String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult _authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = _authResult.user;
    //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    //String fcmToken = await _firebaseMessaging.getToken();
    //if (fcmToken != null) {
    // var tokens = Firestore.instance
    //     .collection('users')
    //     .document(user.uid)
    //     .collection('tokens')
    //     .document(fcmToken);

    // await tokens.setData({
    //   'token': fcmToken,
    //   'createdAt': FieldValue.serverTimestamp(), // optional
    //   'platform': Platform.operatingSystem // optional
    // });
    //}
    return user.uid;
  }

  Future<String> signUp(String userName, String email, String password) async {
    AuthResult _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = _authResult.user;
    if (user != null && userName != null) {
      UserUpdateInfo userdata = UserUpdateInfo();
      userdata.displayName = userName;
      user.updateProfile(userdata);
      //crea un perfil para el usuario
      Firestore.instance.collection("users").document(user.uid).setData({
        'uid': user.uid,
        'userName': userName,
        'created': DateTime.now(),
        'type' : 'visitor',
      });
    } else {
      return 'error';
    }

    // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    // String fcmToken = await _firebaseMessaging.getToken();
    // if (fcmToken != null) {
    //   var tokens = Firestore.instance
    //       .collection('users')
    //       .document(user.uid)
    //       .collection('tokens')
    //       .document(fcmToken);

    //   await tokens.setData({
    //     'token': fcmToken,
    //     'createdAt': FieldValue.serverTimestamp(), // optional
    //     'platform': Platform.operatingSystem // optional
    //   });
    // }

    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    // String fcmToken = await _firebaseMessaging.getToken();
    // if (fcmToken != null) {
    //   var tokens = Firestore.instance
    //       .collection('users')
    //       .document(user.uid)
    //       .collection('tokens')
    //       .document(fcmToken);

    //   await tokens.delete();
    // }

    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
