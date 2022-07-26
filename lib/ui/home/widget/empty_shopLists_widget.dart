import 'package:flutter/material.dart';

class EmptyShopListsWidget extends StatelessWidget {
  final String label;

  const EmptyShopListsWidget({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            "assets/bg/empty_list.png",
            height: 160,
          ),
          const SizedBox(height: 16),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
