

class HandleErrors{

  static String signUpErrors({required String msg}){
    if(msg == "email-already-in-use"){
      return "Este email ja esta sendo usado por outro usuario.";
    }else if(msg == "invalid-email"){
      return "Endereço de email invalido.";
    }else if(msg == "operation-not-allowed"){
      return "Operação não permitida no sistema.";
    }else if(msg == "weak-password"){
      return "Senha muito fraca.";
    }else{
      return "Erro ao criar usuario, se persistir contate um administrador.";
    }
  }

  static String signInErrors(String code){
    if(code == 'invalid-credential'){
      return 'Credenciais invalidas.';
    }else if(code == 'operation-not-allowed'){
      return 'Operação não permitida, contate um administrador.';
    }else if(code == 'user-not-found'){
      return 'Usuário nao encontrado.';
    }else if(code == 'wrong-password'){
      return 'Senha incorreta';
    }else{
      return 'Ocorreu algum problema ao fazer o login, tente novamente em instantes.';
    }
  }


}