import 'package:flutter/material.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductItem extends StatelessWidget {

  final ShopListModel listData;
  final ItemModel item;
  final ShopListController controller;
  final notification = CustomNotification();

  ProductItem({ 
    required this.listData,
    required this.controller,
    required this.item});


  Future<void> deleteItem() async {
    bool success = await controller.deleteItem(
      item: item,
      listId: listData.id!,
    );

    if(!success){
      notification.showSnackErrorWithIcon(text: "Ero ao deletar item, se persistir contate um adminstrador");
    }
  }

  void checkItem(bool check) async {

    listData.products!.map((e){
      if(e.name == item.name){
        e.checked = check;
      }
    }).toList();
    
    bool success = await controller.updateItem(
      itens: listData.products!,
      listId: listData.id!,
    );

    if (!success) {
      notification.showSnackErrorWithIcon(text: "Ero ao atualizar item, se persistir contate um adminstrador");
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
              onPressed: (context) => deleteItem()
            )
          ],
        ),
        child: ListTile(
          title: Text(
            item.name!,
            style: TextStyle(
              decoration: item.checked!
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: item.checked! ? Colors.grey : Colors.black,
              fontSize: 18,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: item.checked,
                activeColor: Colors.green,
                onChanged: (bool? newValue) => checkItem(newValue!),
              ),
              IconButton(
                onPressed: deleteItem,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}