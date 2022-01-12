import 'package:flutter/material.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/shared/theme/app_colors.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';
import 'package:shop_list/ui/home/home_screen.dart';

class AnonymousLogin extends StatelessWidget {

  final LoginController controller;

  AnonymousLogin({required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        controller.loginAnonymous();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder:(context)=> HomeScreen())
        );
      },
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
        child: Center(
          child: Text("Fazer login depois",
            style: AppTextStyle.normalText
          ),
        ),
      ),
    );
  }
}
