import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/ui/home/drawer/custom_drawer_header.dart';
import 'package:shop_list/ui/home/drawer/drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomDrawerHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () {
                var state = loginController.userState?.value;

                if (state == null) return Container();

                return DrawerItem(
                  title: 'Sair',
                  icon: FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    color: thirdColor,
                  ),
                  onTap: () async {
                    await loginController.logOut();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
