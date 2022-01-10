import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/controller/login/login_state.dart';
import 'package:shop_list/shared/app_text_style.dart';
import 'package:shop_list/ui/home/home_screen.dart';
import 'package:shop_list/ui/login/widgets/anonymous_login.dart';
import 'package:shop_list/ui/login/widgets/email_button.dart';
import 'signUp_page.dart';
import 'widgets/google_button.dart';

class LoginScreen extends StatefulWidget {

  final bool autoLogin;

  const LoginScreen({Key? key, this.autoLogin = true}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginController? _loginController;
  StreamSubscription? _loginStateSub;
  bool seePass = true;

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 8),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.error, size: 30, color: Colors.white),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              "Tivemos algum problema ao efetuar o login, espere um pouco e tente novamente.",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    _loginController = context.read<LoginController>();

    if(widget.autoLogin){
      _loginController!.getCurrentUser();
    }

    _loginStateSub = _loginController!.outLoginState.listen((state) {
      switch (state.state) {
        case stateLogin.LOGGED:
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false,
            );
          }
          break;
        case stateLogin.ANONYMOUS:
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false,
            );
          }
          break;
        case stateLogin.ERROR:
          _showError();
          break;
        case stateLogin.LOADING:
        case stateLogin.IDLE:
        default:
      }
    });
  }

  @override
  void dispose() {
    _loginStateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false, // block back button action on this page
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          body: StreamBuilder<LoginState>(
              stream: _loginController!.outLoginState,
              initialData: LoginState(stateLogin.IDLE),
              builder: (context, state) {
                switch (state.data!.state) {
                  case stateLogin.LOADING:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case stateLogin.LOGGED:
                  case stateLogin.ERROR:
                  case stateLogin.IDLE:
                    return _newBody(context, size);
                  default:
                    return Container();
                }
              }),
        ),
      ),
    );
  }

  Widget _newBody(BuildContext context, Size screenSize) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Center(
                      child: FlutterLogo(
                        size: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AnonymousLogin(controller: _loginController!),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Divider(thickness: 0.8,),
                  ),
                  GoogleButton(controller: _loginController!),
                  SizedBox(
                    height: 16,
                  ),
                  EmailButton(controller: _loginController!),
                  SizedBox(
                    height: 22,
                  ),
                  //Reset password
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.blue[800]),
                    child: Text(
                      "Esqueci minha senha",
                      style: AppTextStyle.normalText
                    ),
                    onPressed: () {},
                  ),
                  //Create account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ainda nao tem uma conta?",
                        style: AppTextStyle.normalText
                      ),
                      TextButton(
                        style: TextButton.styleFrom(primary: Colors.blue[800]),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpPage(
                                  loginController: _loginController!)));
                        },
                        child: Text(
                          "criar conta",
                          style: AppTextStyle.normalTextWithColor
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
