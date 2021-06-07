import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  Future<UserCredential> signUp({String email, String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      throw (e);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> storeAdditionalUserInfo(
    File image,
    UserCredential authResult,
    String username,
    String email,
  ) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${authResult.user.uid}.jpg');

    UploadTask upTask = ref.putFile(image);

    final imgUrl = await (await upTask).ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user.uid)
        .set(
      {
        'username': username,
        'email': email,
        'image_url': imgUrl,
      },
    );
  }

  Future<UserCredential> signIn({String email, String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      throw (e);
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    var user = getCurrentUser();
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    return userData;
  }
}
