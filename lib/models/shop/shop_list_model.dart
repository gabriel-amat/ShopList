import 'package:json_annotation/json_annotation.dart';
import 'package:shop_list/models/shop/item_model.dart';

part 'shop_list_model.g.dart';

@JsonSerializable(
  explicitToJson: true
)
class ShopListModel{

  String? id;
  String? name;
  List<ItemModel>? products;

  ShopListModel({
    this.id,
    this.name,
    this.products});

  factory ShopListModel.fromJson(Map<String, dynamic> json, String id)
    => _$ShopListModelFromJson(json)..id = id;

  Map<String, dynamic> toJson()
    => _$ShopListModelToJson(this);

}