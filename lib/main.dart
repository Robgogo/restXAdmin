import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/menu/add_menu_screen.dart';
import './screens/menu/edit_menu_screen.dart';
import './screens/auth_screen.dart';
import './screens/tabs_screen.dart';
import './screens/tables/tables_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, appSnapshot) {
        return MaterialApp(
          title: 'Flutter Chat',
          theme: ThemeData(
              primarySwatch: Colors.red,
              backgroundColor: Colors.red[300],
              accentColor: Colors.deepOrange[300],
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.red[400],
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              )),
          home: appSnapshot.connectionState != ConnectionState.done
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.hasData) {
                      return TabsScreen();
                    }
                    return AuthScreen();
                  },
                ),
          routes: {
            AddMenuItemScreen.routeName: (ctx) => AddMenuItemScreen(),
            EditMenuScreen.routeName: (ctx) => EditMenuScreen(),
            TableScreen.routeName: (ctx) => TableScreen(),
          },
        );
      },
    );
  }
}
