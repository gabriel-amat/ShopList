import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/controller/login/login_state.dart';
import 'package:shop_list/database/preferences_db.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/service/firebase_db.dart';

class ShopListController extends ChangeNotifier{

  final _firebaseDB = FirebaseDB();
  final _preferencesDB = PreferencesDB.instance;

  List<ShopListModel> _shopList = [];
  List<ShopListModel> get shopList => _shopList;
  set shopList (List<ShopListModel> newValue) => _shopList = List.from(newValue);

  //Functions
  //FIREBASE FUNCTIONS-----------------------------------------------
  Future<void> getAllShopListsFromFirebase() async {
    var _shopList = await _firebaseDB.getMyShopLists();
    notifyListeners();
  }

  Future<void> saveListOnFirebase(ShopListModel list) async {
    _firebaseDB.saveNewList(data: list);
  }

  Future<bool> deleteShopList(String docId) async {
    return _firebaseDB.deleteList(listId: docId);
  }

  Future<bool> updateShopList(ShopListModel data) async {
    return _firebaseDB.updateList(data);
  }
  //END FIREBASE FUNCTIONS-----------------------------------------------

  void saveMyListsLocally(){
    _preferencesDB.storeMyLists(shopList);
  }

  void createShopList({
    required String title,
    required LoginController loginController
  }){
    final _data = ShopListModel(
      name: title,
      products: []
    );
    shopList.add(_data);
    saveMyListsLocally();
    notifyListeners();
    if(loginController.loginState.value.state == stateLogin.LOGGED){
      saveListOnFirebase(_data);
    }
  }

  void addItemToShopList({required ShopListModel list, required ItemModel item}){
    shopList.map((e){
      if(e == list){
        e.products!.add(item);
      }
    }).toList();
    saveMyListsLocally();
    notifyListeners();
  }

  void checkItem({
    required ShopListModel list,
    required bool value,
    required ItemModel item}){
    shopList.map((e){
      e.products!.map((p){
        if(p == item){
          p.checked = value;
        }
      }).toList();
    }).toList();
    saveMyListsLocally();
    notifyListeners();
  }

  void editListName({required ShopListModel list, required String name}){
    shopList.map((e){
      if(e == list){
        e.name = name;
      }
    }).toList();

    saveMyListsLocally();
    notifyListeners();
  }

  void deleteList(ShopListModel list){
    _shopList.remove(list);
    saveMyListsLocally();
    notifyListeners();
  }

  void deleteItem({required ItemModel item, required ShopListModel list}){
    shopList.map((e){
      if(e == list){
        e.products!.remove(item);
      }
    }).toList();
    saveMyListsLocally();
    notifyListeners();
  }

  void getLocallyLists() async {
    print("Pegando lista local");
    var shopList = await _preferencesDB.getMyLists();
    notifyListeners();
  }

}