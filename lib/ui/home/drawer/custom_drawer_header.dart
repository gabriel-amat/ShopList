import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/theme/app_colors.dart';
import 'package:shop_list/ui/login/login_screen.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  Widget userOff() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: AppColors.buttonColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Entre para ter acesso a diversas funções.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.to(LoginScreen());
                },
                child: Text(
                  "Entrar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userOn(UserModel user) {
    return Text(
      user.name!,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return Container(
      height: 120,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Image.asset(
              mainLogo,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            Obx(
              () {
                var state = loginController.userState?.value;
                var user = loginController.userData.value;

                if (state == null || user == null) return userOff();

                return userOn(user);
              },
            ),
          ],
        ),
      ),
    );
  }
}
