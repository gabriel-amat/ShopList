import 'package:rxdart/rxdart.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/service/shopList_service.dart';

class ShopListController{

  final shopListService = ShopListService();

  var shopLists = BehaviorSubject<List<ShopListModel>?>();
  Stream<List<ShopListModel>?> get outShopLists => shopLists.stream;

  var listData = BehaviorSubject<ShopListModel?>();
  Stream<ShopListModel?> get outList => listData.stream;


  //Functions
  Future<void> getAllLists(bool update) async {
    if(!shopLists.hasValue || update){
      shopLists.add(await shopListService.getAllLists());
    }
  }

  Future<void> getList(String id) async{
    ShopListModel? _list = await shopListService.getList(id);

    if(_list != null && _list.products != null && _list.products!.isNotEmpty){
      List<ItemModel> _itensChecked = [];
      _list.products!.map((e){
        if(e.checked!){
          _itensChecked.add(e);
        }
      }).toList();
      //Remover os itens checked que estao em ordem aleatorio
      _list.products!.removeWhere((e) => _itensChecked.contains(e));
      //Adiciona no final da lista
      var _newList = _list.products!.followedBy(_itensChecked).toList();
      _list.products = List.from(_newList);
    }

    listData.add(_list);
  }

  Future<bool> createList(ShopListModel list) async {
    bool success = await shopListService.createList(data: list);
    if(success) getAllLists(true);
    return success;
  }

  Future<bool> deleteShopList(String docId) async {
    bool success = await shopListService.deleteList(listId: docId);
    if(success) getAllLists(true);
    return success;
  }

  Future<bool> updateShopList(ShopListModel data) async {
    bool success = await shopListService.updateList(data);
    if (success) getList(data.id!);
    return success;
  }


  Future<bool> deleteItem({required String listId, required ItemModel item}) async {
    bool success = await shopListService.deleteItemFromList(item: item, listId: listId);
    if (success) getList(listId);
    return success;
  }

  Future<bool> addItem({required String listId, required ItemModel item}) async {
    bool success = await shopListService.addItemToList(item: item, listId: listId);
    if (success) getList(listId);
    return success;
  }

  Future<bool> updateItem({required String listId, required List<ItemModel> itens}) async {
    
    bool success = await shopListService.updateItem(listId: listId, itens: itens);
    
    if (success) getList(listId);

    return success;
  }

  void dispose(){
    shopLists.close();
    listData.close();
  }

}