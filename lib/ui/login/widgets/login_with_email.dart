import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_list/controller/login/button_state.dart';
import 'package:shop_list/controller/login/field_state.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:provider/provider.dart';

class LoginWithEmail extends StatefulWidget {
  @override
  _LoginWithEmailState createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {

  LoginController? _loginController;
  bool seePass = false;

  @override
  void initState() {
    _loginController = context.read<LoginController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Login com email",
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            StreamBuilder<FieldState>(
              stream: _loginController!.outEmail,
              initialData: FieldState(),
              builder: (context, email) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enabled: email.data?.enabled,
                    onChanged: _loginController!.inEmail,
                    decoration: InputDecoration(
                        hintText: 'E-mail',
                        border: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                        ),
                        errorText: email.data?.error),
                  ),
                );
              },
            ),
            //Password
            StreamBuilder<FieldState>(
              stream: _loginController!.outPassword,
              initialData: FieldState(),
              builder: (context, pass) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    obscureText: seePass,
                    autocorrect: false,
                    enabled: pass.data?.enabled,
                    onChanged: _loginController!.inPassword,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      border: const OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                      ),
                      errorText: pass.data?.error,
                      suffixIcon: IconButton(
                        icon: seePass == false ? Icon(
                          FontAwesomeIcons.eye,
                          size: 20,
                        ) : Icon(
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
                );
              },
            ),
            // LoginButton
            StreamBuilder<ButtonState>(
              initialData:
              ButtonState(enable: false, loading: false),
              stream: _loginController!.outLoginButtonState,
              builder: (streamContext, snapshot) {
                return InkWell(
                  onTap: snapshot.data!.enable
                      ? () async {
                    await _loginController!.loginWithEmail();
                  }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 50,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: snapshot.data!.loading
                        ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(
                              Colors.white),
                        ))
                        : Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
