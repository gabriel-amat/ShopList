import 'package:flutter/material.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/controller/login/login_state.dart';
import 'package:shop_list/shared/app_colors.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginController = context.read<LoginController>();
    return StreamBuilder<LoginState>(
        stream: loginController.outLoginState,
        builder: (context, state) {
          if (state.hasData && state.data!.state == stateLogin.LOGGED) {
            return Container(
              child: Text("Logado"),
            );
          } else {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              color: AppColors.buttonColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Entre para ter acesso a diversas funções.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)
                    ),
                    SizedBox(height: 8,),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        onPressed: () {},
                        child: Text("Entrar", style: TextStyle(color: Colors.black),),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
