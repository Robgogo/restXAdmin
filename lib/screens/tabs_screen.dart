import 'package:flutter/material.dart';

import '../screens/menu_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/add_menu_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': OrdersScreen(),
      'title': 'Orders',
    },
    {
      'page': MenuScreen(),
      'title': 'Menu',
    },
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      // drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.show_chart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category_outlined),
            label: 'Menu',
          ),
        ],
      ),
      floatingActionButton: _selectedPageIndex == 1
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddMenuItemScreen.routeName);
              },
            )
          : null,
    );
  }
}
