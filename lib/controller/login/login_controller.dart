import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_list/models/user/user_credential_result.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/service/user_service.dart';
import 'package:shop_list/shared/helper/login_validator.dart';
import 'package:shop_list/shared/preferences.dart';
import 'button_state.dart';
import 'field_state.dart';
import 'login_state.dart';
import 'user_photo_state.dart';


class LoginController with LoginValidator{

  final firebaseUser = UserService();

  var userData = BehaviorSubject<UserModel?>();
  Stream<UserModel?> get outUserData => userData.stream;

  var email = BehaviorSubject<String>();
  Stream<FieldState> get outEmail =>
      Rx.combineLatest2(email.stream.transform(emailValidator), outLoginState,
          (FieldState email, LoginState state){
            email.enabled = state.state != stateLogin.LOADING;
            return email;
          }
      );
  Function(String) get inEmail => email.sink.add;

  var password = BehaviorSubject<String>();
  Stream<FieldState> get outPassword =>
      Rx.combineLatest2(password.stream.transform(passwordValidator), outLoginState,
          (FieldState pass, LoginState state){
            pass.enabled = state.state != stateLogin.LOADING;
            return pass;
          }
      );
  Function(String) get inPassword => password.sink.add;

  var loginState = BehaviorSubject<LoginState>.seeded(LoginState(stateLogin.IDLE));
  Stream<LoginState> get outLoginState => loginState.stream;
  Sink<LoginState> get inLoginState => loginState.sink;

  var stateControllerButton = BehaviorSubject<stateButton>.seeded(stateButton.IDLE);
  Stream<stateButton> get outStateButton => stateControllerButton.stream;

  var photoUrl = BehaviorSubject<UserPhotoState>();
  Stream<UserPhotoState> get outPhotoUrl => photoUrl.stream;

  //Estado do botao
  Stream<ButtonState> get outLoginButtonState =>
    Rx.combineLatest3(outEmail, outPassword, outLoginState,
      (FieldState email, FieldState pass, LoginState state){
        return ButtonState(
          loading: state.state == stateLogin.LOADING,
          enable: email.error == null && pass.error == null && state.state != stateLogin.LOADING
        );
      }
    );


  //Functions
  Future<bool> resetPassword(String email) async{
    return await firebaseUser.resetPassword(email: email);
  }

  Future<void> getCurrentUser() async{
    User? _currentUser =  firebaseUser.getUser();
    bool? _anonymousLogin = await MySharedPreferences.getAnonymousLogin();

    if(_currentUser != null){
      loginState.add(LoginState(stateLogin.LOADING));
      if(await loadUserData(needToUpdate: true)){
        loginState.add(LoginState(stateLogin.LOGGED));
      }else{
        logOut();
        loginState.add(LoginState(
            stateLogin.ERROR,
            errorMsg:"Erro ao buscar seus dados, tente novamente em instantes."));
      }
    }else if(_anonymousLogin != null && _anonymousLogin){
      loginState.add(LoginState(stateLogin.ANONYMOUS));
    }else{
      loginState.add(LoginState(stateLogin.IDLE));
    }
  }

  Future<void> loginAnonymous() async {
    await MySharedPreferences.setAnonymousLogin(data: true);
    loginState.add(LoginState(stateLogin.ANONYMOUS));
  }

  Future loginWithGoogle() async{
    loginState.add(LoginState(stateLogin.LOADING));

    UserCredentialResult _user = await firebaseUser.loginWithGoogle();
    if(_user.user == null){
      loginState.add(LoginState(stateLogin.ERROR, errorMsg: _user.message));
    }else{
      await MySharedPreferences.setUserID(id: _user.user!.user!.uid);
      bool _success = await loadUserData(needToUpdate: true);

      if(!_success){
        User userLogged = _user.user!.user!;
        UserModel _userModel = UserModel(
          name: userLogged.displayName,
          celular: userLogged.phoneNumber,
          email: userLogged.email,
          photo: userLogged.photoURL,
        );
        await firebaseUser.saveUserData(_userModel, _user.user!.user!.uid);
        await loadUserData(needToUpdate: true);
      }
      loginState.add(LoginState(stateLogin.LOGGED));
    }
  }

  Future loginWithEmail() async{
    loginState.add(LoginState(stateLogin.LOADING));
    UserCredentialResult _user = await firebaseUser.loginWithEmail(email.value, password.value);

    if(_user.user?.user?.uid == null){
      loginState.add(LoginState(stateLogin.ERROR, errorMsg: _user.message));
    }else{
      await MySharedPreferences.setUserID(id: _user.user!.user!.uid);
      loadUserData(needToUpdate: true);
      loginState.add(LoginState(stateLogin.LOGGED));
    }
  }

  Future<void> signUp({required String email, required String pass, required UserModel userModel}) async{
    loginState.add(LoginState(stateLogin.LOADING));

    UserCredentialResult _res = await firebaseUser.createUser(email: email, pass: pass);

    if(_res.user!.user?.uid != null){
      MySharedPreferences.setUserID(id: _res.user!.user!.uid);

      userModel.id = _res.user!.user!.uid;

      bool _success = await firebaseUser.saveUserData(
        userModel,
        _res.user!.user!.uid
      );

      if(_success){
        loadUserData(needToUpdate: true);
        loginState.add(LoginState(stateLogin.LOGGED));
      }else{
        logOut();
        loginState.add(
            LoginState(stateLogin.ERROR, errorMsg: "Erro ao salvar os dados, se persistir contate um administrador")
        );
      }
    }else{
      logOut();
      loginState.add(
          LoginState(stateLogin.ERROR, errorMsg: _res.message)
      );
    }
  }

  Future<bool> updateUserData({required Map<String, dynamic> data}) async {
    bool result = false;
    stateControllerButton.add(stateButton.LOADING);

    if(await firebaseUser.updateUserData(data: data)){
      if(await loadUserData(needToUpdate: true)){
        stateControllerButton.add(stateButton.IDLE);
        result = true;
      }
    }
    return result;
  }

  Future<bool> loadUserData({required bool needToUpdate}) async{
    print("StreamHasValue?${userData.hasValue}\n NeedToUpdate? $needToUpdate");

    if(userData.hasValue && !needToUpdate) return true;

    if(userData.hasValue && needToUpdate){

      UserModel? _user = await firebaseUser.loadUserData();

      if(_user != null){
        userData.add(_user);
        return true;
      }else{
        return false;
      }
    }

    if(!userData.hasValue){
      UserModel? _user = await firebaseUser.loadUserData();
      if(_user != null){
        userData.add(_user);
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  // Future<bool> saveProfileImage({required firebase_storage.Reference ref}) async{
  //   bool result = false;
  //
  //   var success = await firebaseUser.saveProfileImage(imageRef: ref);
  //
  //   if(success){
  //     if(await loadUserData(needToUpdate: true)){
  //       result = true;
  //     }else{
  //       print("Erro ao carregar os dados do user");
  //     }
  //   }else{
  //     print("Erro ao salvar foto");
  //   }
  //
  //
  //   return result;
  // }

  // Future<void> _deleteCacheDir() async {
  //   final cacheDir = await getTemporaryDirectory();
  //
  //   if(cacheDir.existsSync()){
  //     cacheDir.deleteSync(recursive: true);
  //     print("Cache limpo");
  //   }
  // }

  Future<bool> deleteSharedPreferences() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }
  
  Future<bool> logOut() async{
    print("Saindo...");
    bool result = false;
    if(loginState.hasValue){
      if(loginState.value.state == stateLogin.LOGGED){
        if(await firebaseUser.logout()){
          userData.add(null);
          loginState.add(LoginState(stateLogin.IDLE));
          result = true;
        }
      }else{
        await MySharedPreferences.setAnonymousLogin(data: false);
        loginState.add(LoginState(stateLogin.IDLE));
        result = true;
      }
    }
    return result;
  }

  void dispose(){
    email.close();
    password.close();
    photoUrl.close();
    stateControllerButton.close();
    userData.close();
  }


}