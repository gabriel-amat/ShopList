// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopListModel _$ShopListModelFromJson(Map<String, dynamic> json) =>
    ShopListModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShopListModelToJson(ShopListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'products': instance.products?.map((e) => e.toJson()).toList(),
    };
