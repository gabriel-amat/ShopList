import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/user/user_credential_result.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/service/auth_service.dart';
import 'package:shop_list/shared/preferences.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'package:shop_list/ui/home/home_screen.dart';
import 'package:shop_list/ui/login/login_screen.dart';

import 'package:rxdart/rxdart.dart' as rxDart;

enum LoginState { IDE, LOADING }

class LoginController extends GetxController {
  final service = AuthService();
  final notification = CustomNotification();
  FirebaseAuth _auth = FirebaseAuth.instance;

  late Rx<UserModel?> userData;
  Rx<User?>? userState;
  StreamController<LoginState> loginUIState = rxDart.BehaviorSubject();

  @override
  void onReady() async {
    super.onReady();
    //GetCurrentUser
    userData = Rx<UserModel?>(await service.getCurrentUser());
    //Get user state
    userState = Rx<User?>(_auth.currentUser);
    //Listen to changes
    userState!.bindStream(_auth.userChanges());
    //on every change call this
    ever(userState!, _intialScreen);
  }

  _intialScreen(User? user) {
    if (user == null) {
      loginUIState.add(LoginState.IDE);
      Get.offAll(LoginScreen());
    } else {
      Get.offAll(HomeScreen());
    }
  }

  Future<bool> resetPassword(String email) async {
    return await service.resetPassword(email: email);
  }

  Future loginWithGoogle() async {
    UserCredentialResult _user = await service.loginWithGoogle();

    if (_user.user != null) {
      await MySharedPreferences.setUserID(id: _user.user!.user!.uid);
      bool _success = await loadUserData(true);

      if (!_success) {
        User userLogged = _user.user!.user!;
        UserModel _userModel = UserModel(
          name: userLogged.displayName,
          celular: userLogged.phoneNumber,
          email: userLogged.email,
          photo: userLogged.photoURL,
          id: userLogged.uid,
        );
        userData(_userModel);
        await service.saveUserData(_userModel, _user.user!.user!.uid);
      }
    }
  }

  Future loginWithEmail(String email, String password) async {
    UserCredentialResult _user = await service.loginWithEmail(email, password);

    if (_user.user?.user == null) {
      notification.error(text: _user.message!);
    } else {
      await MySharedPreferences.setUserID(id: _user.user!.user!.uid);
      loadUserData(true);
    }
  }

  Future<void> signUp({
    required String email,
    required String pass,
    required UserModel userModel,
  }) async {
    UserCredentialResult _res = await service.createUser(
      email: email,
      pass: pass,
    );

    if (_res.user == null) {
      logOut();
      notification.error(text: _res.message!);
      return;
    }

    MySharedPreferences.setUserID(id: _res.user!.user!.uid);

    userModel.id = _res.user!.user!.uid;
    print("New user ID ${userModel.id}");
    bool success = await service.saveUserData(
      userModel,
      _res.user!.user!.uid,
    );

    if (!success) {
      logOut();
      notification.error(
        text: "Erro ao salvar os dados, contate um administrador",
      );
      return;
    }

    loadUserData(true);
  }

  Future<bool> updateUserData({required Map<String, dynamic> data}) async {
    bool result = false;

    if (await service.updateUserData(data: data)) {
      if (await loadUserData(true)) {
        result = true;
      }
    }
    return result;
  }

  Future<bool> loadUserData(bool update) async {
    if (userData.value == null || update) {
      UserModel? res = await service.loadUserData();
      if (res == null) {
        notification.error(text: "Erro ao buscar dados do usuario.");
        return false;
      }
      userData(res);
    }
    return true;
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

  Future<bool> deleteSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }

  Future<void> logOut() async {
    Get.delete<ShopListController>();
    await service.logout();
  }
}
