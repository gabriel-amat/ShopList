import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/models/user/user_credential_result.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/shared/helper/handle_errors.dart';
import 'package:shop_list/shared/preferences.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  Future resetPassword({required String email}) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  // Future<bool> removePhotoFromStorage({required String fileName}) async{
  //   bool result = false;
  //   try{
  //
  //     final Reference storageRef = _storage.ref();
  //     final imgRef = storageRef.child("pictures/$fileName.png");
  //
  //     imgRef.delete();
  //
  //     result = true;
  //   }catch(e){
  //     print("Erro ao deletar arquivo $e");
  //     return result;
  //   }
  //   return result;
  // }

  // Future<bool> removePhotoFromDoc() async{
  //   bool result = false;
  //   var id = await MySharedPreferences.getUserId();
  //
  //   if(id != null){
  //     try{
  //       await _db
  //           .collection("users")
  //           .doc(id)
  //           .update({"photo": FieldValue.delete()});
  //       result = true;
  //     }catch(e){
  //       print("Erro ao remover foto do doc $e");
  //     }
  //
  //   }
  //   return result;
  // }

  Future<UserModel?> getCurrentUser() async {
    var loginController = Get.find<LoginController>();
    if (_auth.currentUser != null) {
      loginController.loginUIState.add(LoginState.LOADING);
      return await loadUserData();
    }
    return null;
  }

  Future<UserModel?> loadUserData() async {
    print("-- Loading UserData --");
    var _id = await MySharedPreferences.getUserId();
    if (_id != null) {
      try {
        DocumentSnapshot _doc = await _db.collection("users").doc(_id).get();
        if (_doc.exists) {
          return UserModel.fromJson(_doc.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      } on FirebaseAuthException catch (e) {
        print("Erro loadUserData ${e.code}");
        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> saveUserData(UserModel user, String id) async {
    try {
      await _db.collection("users").doc(id).set(user.toJson());
      return true;
    } catch (e) {
      print("Erro ao salvar dados do user $e");
      return false;
    }
  }

  Future<bool> updateUserData({required Map<String, dynamic> data}) async {
    bool result = false;
    var id = await MySharedPreferences.getUserId();

    if (id != null) {
      try {
        await _db
            .collection("users")
            .doc(id)
            .set(data, SetOptions(merge: true));
        result = true;
      } catch (e) {
        print("Erro ao atualizar dados: $e");
        return result;
      }
    }
    return result;
  }

  Future<bool> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      print("Erro ao tentar sair: ${e.code}");
      return false;
    }
  }

  Future<UserCredentialResult> createUser({
    required String email,
    required String pass,
  }) async {
    UserCredentialResult userResult = UserCredentialResult();

    try {
      userResult.user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseAuthException catch (e) {
      userResult.message = HandleErrors.signUpErrors(msg: e.code);
    }

    return userResult;
  }

  Future<UserCredentialResult> loginWithEmail(String email, String pass) async {
    print("--LoginWithEmail--");
    try {
      UserCredential _user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return UserCredentialResult(user: _user);
    } on FirebaseAuthException catch (e) {
      print("Login error $e");
      String message = "Erro ao entrar, $e";

      if (e.code == "wrong-password") {
        message = "Senha incorreta";
      }

      return UserCredentialResult(message: message);
    }
  }

  // Future<bool> saveProfileImage({required firebase_storage.Reference imageRef}) async{
  //
  //   bool result = true;
  //
  //   UserModel? _user = await loadUserData();
  //
  //   //Deletar foto atual se existir
  //   if(_user != null){
  //     if(_user.photo != null){
  //       bool _success = await removePhotoFromStorage(fileName: _user.id!);
  //       if(_success){
  //         final String _url = await imageRef.getDownloadURL();
  //         updateUserData(data: {'photo': _url});
  //       }else{
  //         result = false;
  //       }
  //     }
  //   }else{
  //     final String _url = await imageRef.getDownloadURL();
  //     bool _success = await updateUserData(data: {'photo': _url});
  //     if(_success == false){
  //       result = false;
  //     }
  //   }
  //
  //   return result;
  // }

  Future<UserCredentialResult> loginWithGoogle() async {
    print("--LoginWithGoogle--");
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return UserCredentialResult(message: "Nenhuma conta selecionada");
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential _user = await _auth.signInWithCredential(credential);
      return UserCredentialResult(user: _user);
    } on FirebaseAuthException catch (e) {
      return UserCredentialResult(message: HandleErrors.signInErrors(e.code));
    }
  }
}
