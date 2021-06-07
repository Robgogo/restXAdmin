import 'package:flutter/material.dart';

import '../../services/menu_service.dart';
import '../../widgets/menu/menu_item.dart';

class MenuScreen extends StatelessWidget {
  final _menuServ = MenuService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _menuServ.streamobject,
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
