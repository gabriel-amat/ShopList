import 'package:flutter/material.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/shared/theme/app_colors.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';
import 'package:shop_list/ui/login/widgets/login_with_email.dart';

class EmailButton extends StatelessWidget {

  final LoginController controller;

  EmailButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder:(context)=> LoginWithEmail())
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.email, color: Colors.grey,),
            Expanded(
              child: Center(
                child: Text("Entrar com Email",
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
