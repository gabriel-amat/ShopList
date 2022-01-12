import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class ItemModel{

  String? id;
  String? name;
  bool? checked;

  ItemModel({
    this.id,
    this.checked = false,
    this.name});

  factory ItemModel.fromJson(Map<String, dynamic> json)
    => _$ItemModelFromJson(json);

  Map<String, dynamic> toJson()
    => _$ItemModelToJson(this);

}
