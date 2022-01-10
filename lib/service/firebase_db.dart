import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/preferences.dart';

class FirebaseDB{

  var _db = FirebaseFirestore.instance;

  Future<List<ShopListModel>> getMyShopLists() async{

    String _id = await MySharedPreferences.getUserId();
    QuerySnapshot _snap = await _db
        .collection("users")
        .doc(_id)
        .collection("lists")
        .get();

    if(_snap.docs.length > 0){
      return List<ShopListModel>.from(
        _snap.docs.map((e){
          ShopListModel.fromJson(
            json: e.data() as Map<String, dynamic>,
            id: e.id
          );
        }).toList()
      );
    }else{
      return [];
    }
  }

  Future<bool> saveNewList({required ShopListModel data}) async {
    String _id = await MySharedPreferences.getUserId();

    try{
      await _db
          .collection("users")
          .doc(_id)
          .collection("lists")
          .add(ShopListModel().toJson(data));
      return true;
    }catch(e){
      print("Erro ao criar shopList $e");
      return false;
    }
  }

  Future<bool> updateList(ShopListModel data) async{
    String _id = await MySharedPreferences.getUserId();
    try{
      await _db
        .collection("users")
        .doc(_id)
        .collection("lists")
        .doc(data.id)
        .delete()
        .catchError((e) => print("Error deleting list $e"));

      await _db
          .collection("users")
          .doc(_id)
          .collection("lists")
          .add(ShopListModel().toJson(data));

      return true;
    } catch(e){
      print("Erro ao editar item $e");
      return false;
    }
  }

  Future<bool> deleteList({required String listId}) async {
    String _id = await MySharedPreferences.getUserId();

    try{
      await _db
          .collection("users")
          .doc(_id)
          .collection("lists")
          .doc(listId)
          .delete();
      return true;
    }catch(e){
      print("Erro ao excluir $e");
      return false;
    }
  }

  Future<bool> deleteItemFromList({required ItemModel item, required String listId}) async {

    String _id = await MySharedPreferences.getUserId();
    List _toDelete = [];
    _toDelete.add(item);
    try{
      await _db
          .collection("users")
          .doc(_id)
          .collection("lists")
          .doc(listId)
          .update({"products": FieldValue.arrayRemove(_toDelete)});

      return true;
    } catch(e){
      print("Erro ao excluir item $e");
      return false;
    }
  }

  Future<bool> addItemToList({required ItemModel item, required String listId}) async {

    String _id = await MySharedPreferences.getUserId();
    List _toAdd = [];
    _toAdd.add(item);
    try{
      await _db
          .collection("users")
          .doc(_id)
          .collection("lists")
          .doc(listId)
          .update({"products": FieldValue.arrayUnion(_toAdd)});

      return true;
    } catch(e){
      print("Erro ao excluir item $e");
      return false;
    }
  }

}