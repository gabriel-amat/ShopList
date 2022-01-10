import 'package:flutter/material.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/shared/app_colors.dart';
import 'package:shop_list/shared/notifications.dart';

class ResetPasswordPage extends StatelessWidget {

  final _email = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _notification = CustomNotification();

  final LoginController loginController;

  ResetPasswordPage({required this.loginController});

  void _onSubmit(BuildContext context) async{
    if(_form.currentState!.validate()){
      bool success = await loginController.resetPassword();

      if(success){
        _notification.showSnackSuccessWithIcon(
          text: "Sucesso, siga os proximos passos no email enviado."
        );
        Navigator.of(context).pop();
      }else{
        _notification.showDialogWaring(
          text: "Aguarde um pouco para reenviar o email.",
          context: context,
          buttonText: "ok"
        );
      }
    }else{
      _notification.showSnackErrorWithIcon(
        text: "Formato de email incorreto."
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Resetar senha"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Digite seu email para alterar a senha.",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  // color: CustomColors.secondaryColor
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (value){
                    if(!value!.contains("@")){
                      return "Digite um email valido.";
                    }else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Digite seu email',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w300
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    primary: AppColors.textColor,
                  ),
                  onPressed: ()=> _onSubmit(context),
                  child: Text("Enviar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 18
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
