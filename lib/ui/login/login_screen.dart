import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'package:shop_list/ui/login/widgets/email_button.dart';
import 'package:shop_list/ui/login/widgets/login_with_email.dart';
import 'signUp_page.dart';
import 'widgets/google_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final snack = CustomNotification();
  final loginController = Get.find<LoginController>();
  bool isLoading = false;

  StreamSubscription? subscriptionState;

  @override
  void initState() {
    subscriptionState = loginController.loginUIState.stream.listen((event) {
      if (event == LoginState.LOADING) {
        snack.loading(text: "Carregando dados do usuário");
      }
    });
    
    super.initState();
  }

  @override
  void dispose() {
    subscriptionState?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      mainLogo,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // AnonymousLogin(controller: _loginController!),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 22),
                //   child: Divider(thickness: 0.8,),
                // ),
                GoogleButton(),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Get.to(LoginWithEmail());
                  },
                  child: EmailButton(),
                ),
              ],
            ),
            //Create account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ainda nao tem uma conta?",
                  style: AppTextStyle.normalText,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blue[800],
                  ),
                  onPressed: () {
                    Get.to(SignUpPage());
                  },
                  child: Text(
                    "criar conta",
                    style: AppTextStyle.normalTextWithColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
