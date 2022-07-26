import 'package:flutter/material.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';

import 'add_item_widget.dart';

class EmptyListWidget extends StatelessWidget {
  final ShopListModel list;
  final Function(ItemModel) onTap;

  const EmptyListWidget({
    Key? key,
    required this.list,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Column(
          children: [
            Image.asset("assets/bg/empty_list.png", height: 160),
            const SizedBox(height: 8),
            Text(
               "Começe a adicionar novos itens.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
          ],
        ),
        AddItemWidget(
          list: list,
          onSubmit: (ItemModel item) => onTap(item),
        ),
      ],
    );
  }
}
