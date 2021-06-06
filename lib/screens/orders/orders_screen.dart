import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/orders/order_item.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("orders")
          .orderBy('createdAt', descending: true)
          .where('restId', isEqualTo: user.uid)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (ctx, i) => Column(
            children: [
              OrderItem(
                name: documents[i].data()['name'],
                orderedBy: documents[i].data()['orderedBy'],
                tableId: documents[i].data()['table'],
                accepted: documents[i].data()['accepted'],
                served: documents[i].data()['served'],
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
