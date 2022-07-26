import 'package:get/get.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/service/shopList_service.dart';
import 'package:shop_list/service/user_service.dart';
import 'package:shop_list/shared/widget/notifications.dart';

class ListUserController extends GetxController {
  final userService = UserService();
  final shopListService = ShopListService();
  final snack = CustomNotification();

  var userWithAccess = <UserModel>[].obs;
  var userWithAccessPending = <UserModel>[].obs;
  var userWithAccessDenied = <UserModel>[].obs;

  Future<ShopListModel?> getListById(String id) async {
    return await shopListService.getListById(id);
  }

  void cleanLists() {
    userWithAccess.clear();
    userWithAccessDenied.clear();
    userWithAccessPending.clear();
  }

  Future<void> getUsersData(ShopListModel data) async {
    print("GetUsersData");
    cleanLists();

    if (data.access != null) {
      for (String id in data.access!) {
        if (id.isNotEmpty) {
          var res = await userService.getUserById(id);
          if (res != null) {
            userWithAccess.add(res);
          }
        }
      }
    }

    if (data.accessPending != null) {
      for (String id in data.accessPending!) {
        if (id.isNotEmpty) {
          var res = await userService.getUserById(id);
          if (res != null) {
            userWithAccessPending.add(res);
          }
        }
      }
    }

    if (data.accessDenied != null) {
      for (String id in data.accessDenied!) {
        if (id.isNotEmpty) {
          var res = await userService.getUserById(id);
          if (res != null) {
            userWithAccessDenied.add(res);
          }
        }
      }
    }
  }
}
