import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/ui/login/login_screen.dart';
import 'package:asuka/asuka.dart' as asuka;

class App extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginController>(
          create: (_) => LoginController(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<ShopListController>(
          create: (_) => ShopListController(),
          dispose: (_, value) => value.dispose(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PotatoShop',
        builder: asuka.builder,
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return LoginScreen();
            }
            return Center(
              child: CircularProgressIndicator(),
            );

          }
        ),
      ),
    );
  }
}