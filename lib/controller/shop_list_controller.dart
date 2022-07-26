import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/models/file_picked_model.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/service/shopList_service.dart';
import 'package:shop_list/shared/preferences.dart';
import 'package:shop_list/shared/widget/notifications.dart';

class ShopListController extends GetxController {
  final listService = ShopListService();
  final snack = CustomNotification();

  FilePickedModel? thumb;
  RxList<ShopListModel> shopLists = RxList();
  RxList<ShopListModel> sharedShopLists = RxList();

  @override
  onReady() {
    getLists();
    super.onReady();
  }

  @override
  onClose() {
    shopLists.close();
    sharedShopLists.close();
    super.onClose();
  }

  bool amICreator(ShopListModel list, String userId) {
    return list.creatorId == userId;
  }

  Future<void> getLists() async {
    shopLists.clear();
    sharedShopLists.clear();

    var userId = await MySharedPreferences.getUserId();

    if (userId == null) {
      snack.error(text: "Erro ao acessar dados do usuario.");
      return;
    }
    print("Shop lists $shopLists");
    shopLists.bindStream(listService.listStream(userId));
    sharedShopLists.bindStream(listService.sharedListStream(userId));
  }

  Future<List<ItemModel>> reorderCheckedItens(List<ItemModel> list) async {
    List<ItemModel> _itensChecked = [];

    list.map((e) {
      if (e.checked!) {
        _itensChecked.add(e);
      }
    }).toList();

    //Remover os itens checked que estao em ordem aleatorio
    list.removeWhere((e) => _itensChecked.contains(e));

    //Adiciona no final da lista de produtos
    var _newList = list.followedBy(_itensChecked).toList();
    //add a nova lista de produtos na ordem certa
    list = List.from(_newList);

    return list;
  }

  Future<bool> createList(ShopListModel list) async {
    final loginController = Get.find<LoginController>();

    final UserModel? user = loginController.userData.value;

    if (user == null) return false;

    list.creator = user;
    list.creatorId = user.id;

    bool success = await listService.createList(data: list, thumb: thumb);
    shopLists.refresh();
    return success;
  }

  Future<bool> deleteShopList(ShopListModel list) async {
    return await listService.deleteList(list: list);
  }

  Future<bool> updateShopList(ShopListModel newValue) async {
    bool success = await listService.updateList(newValue, thumb: thumb);

    for (ShopListModel item in shopLists) {
      if (item.id == newValue.id) {
        item = newValue;
        break;
      }
    }
    shopLists.refresh();

    return success;
  }

  Future<bool> deleteItem({
    required String listId,
    required ItemModel item,
  }) async {
    bool success = await listService.deleteItemFromList(
      item: item,
      listId: listId,
    );
    return success;
  }

  Future<bool> addItem({
    required String listId,
    required ItemModel item,
  }) async {
    bool success = await listService.addItemToList(
      item: item,
      listId: listId,
    );
    return success;
  }

  Future<bool> updateItem({
    required String listId,
    required List<ItemModel> itens,
  }) async {
    String? user = await MySharedPreferences.getUserId();

    if (user == null) {
      snack.error(text: "Erro ao atualizar dados do item, usuario sem ID");
      return false;
    }

    return await listService.updateItem(
      listId: listId,
      itens: itens,
      userId: user,
    );
  }
}
