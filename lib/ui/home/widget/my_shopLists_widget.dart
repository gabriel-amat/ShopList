import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/shop_list_controller.dart';

import 'empty_shopLists_widget.dart';
import 'list_item.dart';

class MyShopListsWidget extends StatelessWidget {
  const MyShopListsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listController = Get.find<ShopListController>();

    return Obx(
      () {
        var list = listController.shopLists;
        if (list.isEmpty) {
          return EmptyShopListsWidget(
            label: "Você ainda não tem nenhuma lista",
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListItem(
              list: list[index],
            );
          },
        );
      },
    );
  }
}
