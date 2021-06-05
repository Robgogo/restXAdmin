import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data.docs;
        // print(documents[0]);
        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (ctx, i) => MessageBuble(
            documents[i].data()['text'],
            documents[i].data()['username'],
            documents[i].data()['userImage'],
            documents[i].data()['userId'] == user.uid,
            key: ValueKey(documents[i].id),
          ),
        );
      },
    );
  }
}
