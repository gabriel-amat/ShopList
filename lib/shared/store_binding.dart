import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/controller/shop_list_controller.dart';

class StoreBiding implements Bindings{

  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.put<ShopListController>(ShopListController());
  }

}