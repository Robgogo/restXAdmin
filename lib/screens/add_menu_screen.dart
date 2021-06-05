import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/menu/add_menu_form.dart';

class AddMenuItemScreen extends StatefulWidget {
  static const routeName = '/add-menu-item';

  @override
  _AddMenuItemScreenState createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  var _isLoading = false;
  void _submitForm(
    String name,
    double price,
    String ingredients,
    File image,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final ref = FirebaseStorage.instance
          .ref()
          .child('menu_images')
          .child('${user.uid}-${name}.jpg');

      UploadTask upTask = ref.putFile(image);

      final imgUrl = await (await upTask).ref.getDownloadURL();

      FirebaseFirestore.instance.collection('menu').add(
        {
          'name': name,
          'price': price,
          'ingredients': ingredients,
          'image': imgUrl,
          'restId': user.uid,
          'restName': userData.data()['username'],
        },
      );
      Navigator.of(context).pop();
    } on PlatformException catch (err) {
      var message = "An error occured, please check your credentials!";

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add menu Item'),
      ),
      body: AddMenuForm(_submitForm, _isLoading),
    );
  }
}
