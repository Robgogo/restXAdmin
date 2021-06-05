import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AddMenuForm extends StatefulWidget {
  final void Function(
    String name,
    double price,
    String ingredients,
    File image,
    BuildContext ctx,
  ) submitHandler;
  final bool loading;
  AddMenuForm(this.submitHandler, this.loading);

  @override
  _AddMenuFormState createState() => _AddMenuFormState();
}

class _AddMenuFormState extends State<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();
  var _name = '';
  var _ingredients = '';
  var _price = 0.0;
  File _image;

  void _pickImage(File img) {
    _image = img;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_image == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Choos an Image!"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitHandler(
        _name.trim(),
        _price,
        _ingredients,
        _image,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  UserImagePicker(_pickImage),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.loading) CircularProgressIndicator(),
                  if (!widget.loading)
                    ElevatedButton(
                      child: Text("Add"),
                      onPressed: _trySubmit,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
