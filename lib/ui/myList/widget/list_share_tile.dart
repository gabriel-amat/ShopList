import 'package:flutter/material.dart';
import 'package:shop_list/models/user/user_model.dart';

class ListShareTile extends StatelessWidget {

  final UserModel user;
  final VoidCallback? onTapFirstOption;
  final VoidCallback? onTapSecondOption;

  const ListShareTile({
    Key? key,
    required this.user,
    this.onTapFirstOption,
    this.onTapSecondOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              user.photo == null
                  ? Container()
                  : CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(user.photo!),
                    ),
              Expanded(child: Text(user.name!)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  onTapFirstOption != null
                      ? IconButton(
                          onPressed: onTapFirstOption,
                          icon: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        )
                      : Container(),
                  onTapSecondOption != null
                      ? IconButton(
                          onPressed: onTapSecondOption,
                          icon: Icon(
                            Icons.block,
                            color: Colors.red,
                          ),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
