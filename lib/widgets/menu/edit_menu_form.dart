import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/menu_service.dart';

class EditMenuForm extends StatefulWidget {
  final void Function(
    String id,
    String name,
    double price,
    String ingredients,
    BuildContext ctx,
  ) submitHandler;
  final bool loading;
  final String menuItemId;
  EditMenuForm(this.submitHandler, this.loading, this.menuItemId);

  @override
  _EditMenuFormState createState() => _EditMenuFormState();
}

class _EditMenuFormState extends State<EditMenuForm> {
  final _menuServ = MenuService();
  final _formKey = GlobalKey<FormState>();
  var _name = '';
  var _ingredients = '';
  var _price = 0.0;
  var _imgUrl = '';

  @override
  void initState() {
    super.initState();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitHandler(
        widget.menuItemId,
        _name.trim(),
        _price,
        _ingredients.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _menuServ.getMenuItem(widget.menuItemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data.data();

          _name = data['name'];
          _ingredients = data['ingredients'];
          _price = data['price'];
          _imgUrl = data['image'];
          return Center(
            child: Card(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          key: ValueKey('name'),
                          initialValue: _name,
                          validator: (value) {
                            if (value.isEmpty || value.length < 4) {
                              return "Please enter a valid menu name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                          onSaved: (value) {
                            _name = value;
                          },
                        ),
                        TextFormField(
                          key: ValueKey('ingredients'),
                          initialValue: _ingredients,
                          validator: (value) {
                            if (value.isEmpty || value.length < 4) {
                              return "Please enter appropriate ingredients separated by coma!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Ingredients',
                          ),
                          onSaved: (value) {
                            _ingredients = value;
                          },
                        ),
                        TextFormField(
                          key: ValueKey('price'),
                          initialValue: _price.toString(),
                          validator: (value) {
                            if (value.isEmpty || double.parse(value) <= 0) {
                              return "Please input a valid price";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Price',
                          ),
                          onSaved: (value) {
                            _price = double.parse(value);
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(_imgUrl),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        if (widget.loading) CircularProgressIndicator(),
                        if (!widget.loading)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                child: Text("Update"),
                                onPressed: _trySubmit,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
