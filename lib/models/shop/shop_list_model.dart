import 'package:json_annotation/json_annotation.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/user/user_model.dart';

part 'shop_list_model.g.dart';

@JsonSerializable(
  explicitToJson: true
)
class ShopListModel{

  String? id;
  String? name;
  String? creatorId;
  String? thumb;
  List<ItemModel>? products;
  List<String>? access;
  List<String>? accessPending;
  List<String>? accessDenied;
  UserModel? creator;

  ShopListModel({
    this.thumb,
    this.creatorId,
    this.creator,
    this.access,
    this.accessPending,
    this.accessDenied,
    this.id,
    this.name,
    this.products});

  factory ShopListModel.fromJson(Map<String, dynamic> json)
    => _$ShopListModelFromJson(json);

  Map<String, dynamic> toJson()
    => _$ShopListModelToJson(this);

}