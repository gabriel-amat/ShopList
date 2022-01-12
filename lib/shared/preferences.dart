import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences{

  //SETERS
  static Future setUserID({required String id}) async{
    SharedPreferences idFirebase = await SharedPreferences.getInstance();
    idFirebase.setString("userId", id);
  }

  static Future setAnonymousLogin({required bool data}) async{
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setBool("anonymousLogin", data);
  }

  //GETERS
  static Future<String?> getUserId() async{
    SharedPreferences idFirebase = await SharedPreferences.getInstance();
    return idFirebase.getString("userId");
  }

  static Future<bool?> getAnonymousLogin() async{
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool("anonymousLogin");
  }

}