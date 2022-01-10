import 'dart:convert';
import 'package:shop_list/models/shop/item_model.dart';

class ShopListModel{

  String? id;
  String? name;
  List<ItemModel>? products;

  ShopListModel({
    this.id,
    this.name,
    this.products});

  factory ShopListModel.fromJson({required Map<String, dynamic> json, required String id}){
    return ShopListModel(
      name: json['name'],
      id: id,
      products: List<ItemModel>.from(json['products'].map((e) =>
          ItemModel.fromJson(e)).toList())

    );
  }

  Map<String, dynamic> toJson(ShopListModel shop) => {
    'id': shop.id,
    'name': shop.name,
    'products': shop.products != null
        ? shop.products!.map((e) => e.toJson(e)).toList() : [],
  };

  static String encode(List<ShopListModel> shop) =>
    json.encode(shop.map<Map<String, dynamic>>(
      (item) => ShopListModel().toJson(item)
    ).toList(),
  );

  static List<ShopListModel> decode(String shopLists) =>
    (json.decode(shopLists) as List<dynamic>)
        .map((item) => ShopListModel.fromJson(json: item, id: item['id']))
        .toList();

}