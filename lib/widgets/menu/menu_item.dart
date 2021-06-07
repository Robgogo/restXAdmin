import 'package:flutter/material.dart';

import '../../services/menu_service.dart';
import '../../screens/menu/edit_menu_screen.dart';

class MenuItem extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String ingredients;
  final String menuId;

  MenuItem({
    this.name,
    this.menuId,
    this.imgUrl,
    this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(ingredients),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditMenuScreen.routeName, arguments: menuId);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                MenuService().deleteMenuItem(menuId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
