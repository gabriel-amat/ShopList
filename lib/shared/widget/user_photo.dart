import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/controller/login/login_state.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/ui/login/login_screen.dart';
import 'package:shop_list/ui/profile/profile_screen.dart';

import '../app_colors.dart';


class UserPhotoWidget extends StatelessWidget {
  const UserPhotoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var loginController = context.read<LoginController>();

    return StreamBuilder<UserModel?>(
      stream: loginController.outUserData,
      builder: (context, user) {
        return InkWell(
          onTap: (){
            if(loginController.loginState.hasValue){
              if(loginController.loginState.value.state != stateLogin.LOGGED){
                loginController.inLoginState.add(LoginState(stateLogin.IDLE));
                Navigator.of(context).push(
                    MaterialPageRoute(builder:(context)=> LoginScreen(
                      autoLogin: false,
                    ))
                );
              }else{
                Navigator.of(context).push(
                  MaterialPageRoute(builder:(context)=> ProfileScreen())
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.buttonColor,
              ),
              child: user.hasData && user.data!.photo != null ? Image.network(
                user.data!.photo!,
                fit: BoxFit.cover,
                ) : Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: Icon(
                    FontAwesomeIcons.user,
                    color: Colors.white,
                    size: 18,
                  ),
              )
            ),
          ),
        );
      }
    );
  }
}
