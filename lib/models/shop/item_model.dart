import 'dart:convert';

class ItemModel{

  String? id;
  String? name;
  bool? checked;

  ItemModel({
    this.id,
    this.checked = false,
    this.name,});

  factory ItemModel.fromJson(Map<String, dynamic> json){
    return ItemModel(
        name: json['name'],
        id: json['id'],
        checked: json['checked'],
    );
  }

  Map<String, dynamic> toJson(ItemModel item) => {
    'id': item.id,
    'name': item.name,
    'checked': item.checked,
  };

  static String encode(List<ItemModel> item) =>
    json.encode(item.map<Map<String, dynamic>>(
      (item) => ItemModel().toJson(item)).toList());

  static List<ItemModel> decode(String item) =>
    (json.decode(item) as List<dynamic>)
      .map<ItemModel>((item) => ItemModel.fromJson(item))
      .toList();

}
