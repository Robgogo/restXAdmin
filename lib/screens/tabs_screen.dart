import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './menu/menu_screen.dart';
import './orders/orders_screen.dart';
import './menu/add_menu_screen.dart';
import './tables/tables_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;

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

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: _pages.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pages.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("RestX"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code),
              onPressed: () {
                // go to tables screen
                Navigator.of(context).pushNamed(TableScreen.routeName);
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
          bottom: TabBar(
            controller: _controller,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color: Theme.of(context).accentColor),
            tabs: [
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.show_chart),
                    SizedBox(
                      width: 12,
                    ),
                    Text("Orders"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.category_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text("Menu"),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            OrdersScreen(),
            MenuScreen(),
          ],
        ),
        // drawer: MainDrawer(),
        // body: _pages[_selectedPageIndex]['page'],
        // bottomNavigationBar: BottomNavigationBar(
        //   onTap: _selectPage,
        //   backgroundColor: Theme.of(context).primaryColor,
        //   unselectedItemColor: Colors.white,
        //   selectedItemColor: Theme.of(context).accentColor,
        //   currentIndex: _selectedPageIndex,
        //   type: BottomNavigationBarType.shifting,
        //   items: [
        //     BottomNavigationBarItem(
        //       backgroundColor: Theme.of(context).primaryColor,
        //       icon: Icon(Icons.show_chart),
        //       label: 'Orders',
        //     ),
        //     BottomNavigationBarItem(
        //       backgroundColor: Theme.of(context).primaryColor,
        //       icon: Icon(Icons.category_outlined),
        //       label: 'Menu',
        //     ),
        //   ],
        // ),
        floatingActionButton: _selectedIndex == 1
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddMenuItemScreen.routeName);
                },
              )
            : null,
      ),
    );
  }
}
