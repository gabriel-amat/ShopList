// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopListModel _$ShopListModelFromJson(Map<String, dynamic> json) =>
    ShopListModel(
      thumb: json['thumb'] as String?,
      creatorId: json['creatorId'] as String?,
      creator: json['creator'] == null
          ? null
          : UserModel.fromJson(json['creator'] as Map<String, dynamic>),
      access:
          (json['access'] as List<dynamic>?)?.map((e) => e as String).toList(),
      accessPending: (json['accessPending'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accessDenied: (json['accessDenied'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
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
      'creatorId': instance.creatorId,
      'thumb': instance.thumb,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'access': instance.access,
      'accessPending': instance.accessPending,
      'accessDenied': instance.accessDenied,
      'creator': instance.creator?.toJson(),
    };
