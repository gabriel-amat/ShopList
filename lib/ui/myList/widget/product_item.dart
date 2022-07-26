import 'package:flutter/material.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductItem extends StatefulWidget {
  final ShopListModel listData;
  final ItemModel item;
  final ShopListController controller;
  final Function(ItemModel) onDelete;

  ProductItem({
    required this.listData,
    required this.controller,
    required this.item,
    required this.onDelete,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final notification = CustomNotification();

  void checkItem(bool check) async {
    print("===================================");
    print("Check item with value => $check");
    print("Item id ${widget.item.id}");
    print("Item name ${widget.item.name}");
    print("===================================");

    setState(() => widget.item.checked = check);

    widget.listData.products!.map((e){
      if(e.id == widget.item.id){
        print("Tem id igual");
        e.checked = check;
      }
    }).toList();
  
    bool res = await widget.controller.updateItem(
      itens: widget.listData.products!,
      listId: widget.listData.id!,
    );
    if (!res) {
      setState(() => widget.item.checked = check);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: BehindMotion(),
          children: [
            SlidableAction(
              label: "Excluir",
              icon: Icons.delete,
              backgroundColor: thirdColor,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              onPressed: (context) => widget.onDelete(widget.item),
            )
          ],
        ),
        child: CheckboxListTile(
          title: Text(
            widget.item.name!,
            style: TextStyle(
              decoration: widget.item.checked!
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: widget.item.checked! ? Colors.grey : Colors.black,
              fontSize: 18,
            ),
          ),
          value: widget.item.checked,
          activeColor: secondColor,
          onChanged: (bool? value){
            checkItem(value!);
          },
        ),
      ),
    );
  }
}
