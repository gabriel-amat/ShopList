import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/models/user/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginController = Get.find<LoginController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        title: Obx(() {
          UserModel? userData = loginController.userData.value;

          if (userData == null) return Container();

          if (userData.name == null)
            return Text(
              loginController.userData.value!.email!,
              style: TextStyle(color: Colors.black),
            );

          return Text(
            loginController.userData.value!.name!,
            style: TextStyle(color: Colors.black),
          );
        }),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [],
      ),
    );
  }
}
