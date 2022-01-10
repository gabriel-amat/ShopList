import 'package:firebase_auth/firebase_auth.dart';

class UserCredentialResult{

  UserCredential? user;
  String? message;

  UserCredentialResult({this.message, this.user});
}