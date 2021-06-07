import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/menu/add_menu_form.dart';
import '../../services/menu_service.dart';

class AddMenuItemScreen extends StatefulWidget {
  static const routeName = '/add-menu-item';

  @override
  _AddMenuItemScreenState createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  var _menuServ = MenuService();
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
      await _menuServ.addMenuItem(name, price, ingredients, image);
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
        title: Text('Add menu Item'),
      ),
      body: AddMenuForm(_submitForm, _isLoading),
    );
  }
}
