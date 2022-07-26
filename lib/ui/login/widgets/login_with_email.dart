import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';
import 'package:shop_list/ui/login/reset_password.dart';

class LoginWithEmail extends StatefulWidget {
  @override
  _LoginWithEmailState createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  final _loginController = Get.find<LoginController>();
  bool seePass = false;
  bool isLoading = false;
  final formState = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> onSubmit() async {
    setState(() => isLoading = true);

    if (formState.currentState!.validate()) {
      await _loginController.loginWithEmail(email.text, password.text);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Login com email",
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //Email
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value != null && !value.contains("@")) {
                      return 'Digite um email valido';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              //Password
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: password,
                  obscureText: seePass,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value != null && value.length < 6) {
                      return 'Digite uma senha valida';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: IconButton(
                      icon: seePass == false
                          ? Icon(
                              FontAwesomeIcons.eye,
                              size: 20,
                            )
                          : Icon(
                              FontAwesomeIcons.eyeSlash,
                              size: 20,
                            ),
                      onPressed: () {
                        setState(() => seePass = !seePass);
                      },
                    ),
                  ),
                ),
              ),
              //Reset password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(primary: thirdColor),
                  child: Text(
                    "Esqueci minha senha",
                    style: TextStyle(
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  onPressed: () {
                    Get.to(ResetPasswordPage());
                  },
                ),
              ),
              // LoginButton
              InkWell(
                onTap: onSubmit,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Entrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
