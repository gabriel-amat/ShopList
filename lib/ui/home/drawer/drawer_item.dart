import 'package:flutter/material.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';

class DrawerItem extends StatelessWidget {

  final String title;
  final Widget icon;
  final VoidCallback onTap;

  const DrawerItem({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: icon,
        title: Text(title,
          style: AppTextStyle.normalText,
        ),
      ),
    );
  }
}
