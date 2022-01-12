import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/preferences.dart';

class ShopListService{

  var _db = FirebaseFirestore.instance;

  Future<List<ShopListModel>?> getAllLists() async{
    String? _id = await MySharedPreferences.getUserId();

    if(_id != null){
      try{
        QuerySnapshot _snap = await _db
          .collection("users")
          .doc(_id)
          .collection("lists")
          .get();

         return _snap.docs
            .map((e) =>
                ShopListModel.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
      } catch (e){
        print("Erro ao retornar listas $e");
      }
    }
    return [];
  }

  Future<ShopListModel?> getList(String id) async {
    String? _id = await MySharedPreferences.getUserId();

    if(_id != null){
      try {
        DocumentSnapshot _res = await _db
            .collection("users")
            .doc(_id)
            .collection("lists")
            .doc(id)
            .get();

        return ShopListModel.fromJson(
            _res.data() as Map<String, dynamic>, _res.id);
      } catch (e) {
        print("Erro ao pegar list $e");
      }
    }
    return null;
  }

  Future<bool> createList({required ShopListModel data}) async {
    String? _id = await MySharedPreferences.getUserId();

    if(_id != null){
      try {
        await _db
            .collection("users")
            .doc(_id)
            .collection("lists")
            .add(data.toJson());
        return true;
      } catch (e) {
        print("Erro ao criar shopList $e");
      }
    }
    return false;
  }

  Future<bool> updateList(ShopListModel data) async{
    String? _id = await MySharedPreferences.getUserId();

    if(_id != null){
      try {
        await _db
            .collection("users")
            .doc(_id)
            .collection("lists")
            .doc(data.id)
            .update(data.toJson());

        return true;
      } catch (e) {
        print("Erro ao editar item $e");
      }
    }
    return false;
  }

  Future<bool> deleteList({required String listId}) async {
    String? _id = await MySharedPreferences.getUserId();

    if(_id != null){
      try {
        await _db
            .collection("users")
            .doc(_id)
            .collection("lists")
            .doc(listId)
            .delete();
        return true;
      } catch (e) {
        print("Erro ao excluir $e");
      }
    }
    return false;
  }


  Future<bool> updateItem({required List<ItemModel> itens, required String listId}) async {
    String? _id = await MySharedPreferences.getUserId();

    if(_id != null){
      try {
        await _db
            .collection("users")
            .doc(_id)
            .collection("lists")
            .doc(listId)
            .update({
              "products": itens.map((e) => e.toJson()).toList()
            });

        return true;
      } catch (e) {
        print("Erro ao editar item $e");
      }
    }
    return false;
  }

  Future<bool> deleteItemFromList({required ItemModel item, required String listId}) async {
    String? _id = await MySharedPreferences.getUserId();

    if(_id != null){
      try {
        await _db
            .collection("users")
            .doc(_id)
            .collection("lists")
            .doc(listId)
            .update({
              "products": FieldValue.arrayRemove([item.toJson()])
            });

        return true;
      } catch (e) {
        print("Erro ao excluir item $e");
      }
    }
    return false;
  }

  Future<bool> addItemToList({required ItemModel item, required String listId}) async {
    String? _id = await MySharedPreferences.getUserId();

    if(_id != null){
       try {
        await _db
          .collection("users")
          .doc(_id)
          .collection("lists")
          .doc(listId)
          .update({
            "products": FieldValue.arrayUnion([item.toJson()])
          });

        return true;
      } catch (e) {
        print("Erro ao adicionar item $e");
      }
    }
    return false;
  }

}