import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel{

  String? name;
  String? sobreNome;
  String? email;
  String? photo;
  String? celular;
  String? id;
  String? sangue;

  UserModel({
    this.photo,
    this.sobreNome,
    this.email,
    this.name,
    this.id,
    this.celular,
    this.sangue
  });

  factory UserModel.fromJson(Map<String, dynamic> json)=>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson()=>
      _$UserModelToJson(this);

}
