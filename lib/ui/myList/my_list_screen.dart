import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/controller/list_user_controller.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'package:shop_list/ui/myList/widget/custom_appBar.dart';
import 'package:shop_list/ui/myList/widget/empty_list_widget.dart';
import 'package:shop_list/ui/myList/widget/product_item.dart';
import 'widget/add_item_widget.dart';

class MyListScreen extends StatefulWidget {
  final ShopListModel list;

  MyListScreen({required this.list});

  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  final shopListController = Get.find<ShopListController>();
  final listUserController = Get.put(ListUserController());
  final snack = CustomNotification();

  @override
  void initState() {
    // reOrderList();
    shopListController.thumb = null;
    super.initState();
  }

  Future<void> reOrderList() async {
    if (widget.list.products != null) {
      var res = await shopListController.reorderCheckedItens(
        widget.list.products!,
      );
      widget.list.products = res;
    }
  }

  Future<void> onDelete(ItemModel item) async {
    print("Delete item $item");
    setState(() => widget.list.products!.remove(item));
    bool success = await shopListController.deleteItem(
      item: item,
      listId: widget.list.id!,
    );

    if (!success) {
      setState(() => widget.list.products!.add(item));
      snack.error(
        text: "Ero ao deletar item, se persistir contate um adminstrador",
      );
    }
  }

  Future<void> addItem(ItemModel item) async {
    if (widget.list.products == null) {
      widget.list.products = [];
    }
    setState(() => widget.list.products!.add(item));

    bool success = await shopListController.addItem(
      item: item,
      listId: widget.list.id!,
    );
    if (!success) {
      setState(() => widget.list.products!.remove(item));
      snack.error(
        text: "Erro ao adicionar item, se persisitir contate um administrador",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: CustomAppbar(
          list: widget.list,
        ),
      ),
      body: widget.list.products == null || widget.list.products!.isEmpty
          ? EmptyListWidget(
              list: widget.list,
              onTap: (ItemModel value) => addItem(value),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Itens", style: AppTextStyle.title),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.list.products!.length,
                        itemBuilder: (context, index) {
                          return ProductItem(
                            controller: shopListController,
                            item: widget.list.products![index],
                            listData: widget.list,
                            onDelete: (ItemModel item) => onDelete,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AddItemWidget(
                  list: widget.list,
                  onSubmit: (ItemModel item) => addItem(item),
                ),
              ],
            ),
    );
  }
}
