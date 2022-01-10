import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/controller/login/login_state.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/shared/app_colors.dart';
import 'package:shop_list/shared/notifications.dart';
import 'package:shop_list/ui/home/home_screen.dart';

class SignUpPage extends StatefulWidget {

  final LoginController loginController;

  SignUpPage({required this.loginController});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _nome = TextEditingController();
  final _notification = CustomNotification();
  bool seePass = true;

  @override
  void initState() {
    widget.loginController.outLoginState.listen((state) {
      switch(state.state){
        case stateLogin.LOGGED:
          if(mounted){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false
            );
          }
          break;
        case stateLogin.ERROR:
          _notification.showSnackErrorWithIcon(
              text: state.errorMsg!,
              icon: Icons.error
          );
          break;
        case stateLogin.LOADING:
        case stateLogin.IDLE:
        default:
      }
    });
    super.initState();
  }

  void _onSubmit(BuildContext context) async{
    if(_form.currentState!.validate()){
      UserModel user = UserModel();
      user.email = _email.text;
      user.name = _nome.text;

      //Criando conta no firebase
      await widget.loginController.signUp(
          pass: _pass.text,
          email: _email.text,
          userModel: user
      );
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
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back_rounded)
                ),
                SizedBox(height: 22,),
                Text("Criação de conta",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textColor
                  ),
                ),
                SizedBox(height: 25,),
                Text("Dados de acesso",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textColor
                  ),
                ),
                SizedBox(height: 8,),
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
                        validator: (value){
                          if(!value!.contains("@")){
                            return "Digite um email valido";
                          }else{
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 8,),
                      //password
                      TextFormField(
                        obscureText: seePass,
                        autocorrect: false,
                        controller: _pass,
                        validator: (value){
                          if(value!.length < 7){
                            return "A senha deve conter no minimo 7 caracteres";
                          }else{
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          suffixIcon: IconButton(
                            icon: seePass == false ? Icon(FontAwesomeIcons.eye, size: 20,) : Icon(FontAwesomeIcons.eyeSlash, size: 20,),
                            onPressed: (){
                              setState(() {
                                seePass = !seePass;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("A senha deve conter no minimo 7 caracteres",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                      SizedBox(height: 8,),
                      //Nome
                      TextFormField(
                        controller: _nome,
                        autocorrect: false,
                        validator: (value){
                          if(value != null && value.length < 2){
                            return "Digite um nome valido";
                          }else{
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22),
                //Button
                StreamBuilder<LoginState>(
                  stream: widget.loginController.outLoginState,
                  initialData: LoginState(stateLogin.IDLE),
                  builder: (context, state) {
                    return Container(
                      width: double.maxFinite,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          primary: AppColors.buttonColor
                        ),
                        onPressed: state.data!.state == stateLogin.LOADING ? null : () => _onSubmit(context),
                        child: state.data!.state == stateLogin.LOADING ?
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white
                              ),
                            ),
                          ) : Text("Criar conta",
                            style: TextStyle(
                              color: AppColors.buttonTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
