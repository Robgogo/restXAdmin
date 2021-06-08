import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './auth_service.dart';

class OrderService {
  var auth = AuthService();
  User user = AuthService().getCurrentUser();
  final orderCollection = FirebaseFirestore.instance.collection("orders");

  Stream<QuerySnapshot<Map<String, dynamic>>> get streamobject {
    return orderCollection
        .orderBy('createdAt', descending: true)
        .where('restId', isEqualTo: user.uid)
        .snapshots();
  }

  Future<void> acceptOrder(String id) async {
    await orderCollection.doc(id).update({'accepted': true});
  }

  Future<void> serveOrder(String id) async {
    await orderCollection.doc(id).update({'served': true});
  }
}
