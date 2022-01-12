import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/shared/theme/app_colors.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';

class GoogleButton extends StatelessWidget {

  final LoginController controller;

  GoogleButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.loginWithGoogle,
      child: Container(
        height: 50,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.textColor,
            width: 0.5
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FaIcon(FontAwesomeIcons.google, color: Colors.grey,),
            Expanded(
              child: Center(
                child: Text("Entrar com Google",
                  style: AppTextStyle.normalText
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
