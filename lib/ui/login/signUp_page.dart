import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/theme/app_colors.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final loginController = Get.find<LoginController>();
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _nome = TextEditingController();
  bool seePass = true;
  bool isLoading = false;

  void _onSubmit() async {
    if (_form.currentState!.validate()) {
      UserModel user = UserModel();
      user.email = _email.text;
      user.name = _nome.text;

      setState(() => isLoading = true);
      //Criando conta no firebase
      await loginController.signUp(
        pass: _pass.text,
        email: _email.text,
        userModel: user,
      );
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(height: 22),
                Text(
                  "Criação de conta",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "Dados de acesso",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Email
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (value) {
                          if (!value!.contains("@")) {
                            return "Digite um email valido";
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
                      const SizedBox(height: 8),
                      //password
                      TextFormField(
                        obscureText: seePass,
                        autocorrect: false,
                        controller: _pass,
                        validator: (value) {
                          if (value!.length < 7) {
                            return "A senha deve conter no minimo 7 caracteres";
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
                              setState(() {
                                seePass = !seePass;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "A senha deve conter no minimo 7 caracteres",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      //Nome
                      TextFormField(
                        controller: _nome,
                        autocorrect: false,
                        validator: (value) {
                          if (value != null && value.length < 2) {
                            return "Digite um nome valido";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                //Button
                Container(
                  width: double.maxFinite,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: primaryColor,
                    ),
                    onPressed: _onSubmit,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            "Criar conta",
                            style: TextStyle(
                              color: AppColors.buttonTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
