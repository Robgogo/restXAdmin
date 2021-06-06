import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../widgets/menu/edit_menu_form.dart';

class EditMenuScreen extends StatefulWidget {
  static const routeName = '/edit-menu-item';

  @override
  _EditMenuScreenState createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  var _isInit = true;
  String _id = 'dede';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final menuId = ModalRoute.of(context).settings.arguments as String;
      if (menuId != null) {
        _id = menuId;
      }
    }
    super.didChangeDependencies();
  }

  var _isLoading = false;
  void _submitForm(
    String id,
    String name,
    double price,
    String ingredients,
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

      FirebaseFirestore.instance.collection('menu').doc(id).update(
        {
          'name': name,
          'price': price,
          'ingredients': ingredients,
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
        title: Text('Edit menu Item'),
      ),
      body: EditMenuForm(_submitForm, _isLoading, _id),
    );
  }
}
