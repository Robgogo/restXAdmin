import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/menu/menu_item.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("menu")
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
              MenuItem(
                imgUrl: documents[i].data()['image'],
                ingredients: documents[i].data()['ingredients'],
                name: documents[i].data()['name'],
                menuId: documents[i].id,
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
