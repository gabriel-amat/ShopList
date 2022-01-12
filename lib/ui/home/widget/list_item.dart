import 'package:flutter/material.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';
import 'package:shop_list/ui/myList/my_list_screen.dart';

class ListItem extends StatelessWidget {

  final ShopListModel list;

  const ListItem({ Key? key, required this.list }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyListScreen(list: list),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Container(
            child: ListTile(
              title: Text(list.name!, style: AppTextStyle.normalText),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}