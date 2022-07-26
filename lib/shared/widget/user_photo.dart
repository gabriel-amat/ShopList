import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/ui/profile/profile_screen.dart';
import '../theme/app_colors.dart';

class UserPhotoWidget extends StatelessWidget {
  const UserPhotoWidget({Key? key}) : super(key: key);

  Widget userPhoto(UserModel user) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(user.photo!),
        ),
      ),
    );
  }

  Widget empty() {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        FontAwesomeIcons.user,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return Obx(
      () {
        var user = loginController.userData.value;
        if (user == null) return empty();

        return InkWell(
          onTap: () {
            Get.to(ProfileScreen());
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: user.photo != null ? userPhoto(user) : empty(),
          ),
        );
      },
    );
  }
}
