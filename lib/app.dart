import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/shared/store_binding.dart';
import 'package:shop_list/ui/login/login_screen.dart';

class App extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShopList',
        initialBinding: StoreBiding(),
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error"),
                ),
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
      );
  }
}