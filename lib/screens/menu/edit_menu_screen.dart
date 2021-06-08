import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/menu/edit_menu_form.dart';
import '../../services/menu_service.dart';

class EditMenuScreen extends StatefulWidget {
  static const routeName = '/edit-menu-item';

  @override
  _EditMenuScreenState createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  var _menuServ = MenuService();
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
    String category,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _menuServ.editMenuItem(id, name, price, ingredients, category);
      Navigator.of(context).pop();
    } on PlatformException catch (err) {
      var message = "An error occured, please check your credentials!";

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
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
