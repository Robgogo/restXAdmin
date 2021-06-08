import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './auth_service.dart';

class MenuService {
  var auth = AuthService();
  User user = AuthService().getCurrentUser();
  FirebaseStorage storage = FirebaseStorage.instance;

  final menuCollection = FirebaseFirestore.instance.collection("menu");

  Stream<QuerySnapshot<Map<String, dynamic>>> get streamobject {
    return menuCollection.where('restId', isEqualTo: user.uid).snapshots();
  }

  Future<void> addMenuItem(
    String name,
    double price,
    String ingredients,
    String category,
    File image,
  ) async {
    final userData = await auth.getUserData();

    final ref = FirebaseStorage.instance
        .ref()
        .child('menu_images')
        .child('${user.uid}-$name.jpg');

    UploadTask upTask = ref.putFile(image);

    final imgUrl = await (await upTask).ref.getDownloadURL();

    await menuCollection.add(
      {
        'name': name,
        'price': price,
        'ingredients': ingredients,
        'category': category,
        'image': imgUrl,
        'restId': user.uid,
        'restName': userData.data()['username'],
      },
    );
  }

  Future<void> editMenuItem(
    String id,
    String name,
    double price,
    String ingredients,
    String category,
  ) async {
    final userData = await auth.getUserData();

    await menuCollection.doc(id).update(
      {
        'name': name,
        'price': price,
        'ingredients': ingredients,
        'category': category,
        'restId': user.uid,
        'restName': userData.data()['username'],
      },
    );
  }

  Future<void> deleteMenuItem(String id) {
    menuCollection.doc(id).delete();
  }

  Future<DocumentSnapshot<Object>> getMenuItem(String id) async {
    var doc = await menuCollection.doc(id).get();
    return doc;
  }
}
