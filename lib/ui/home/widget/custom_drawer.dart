import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/controller/login/login_state.dart';
import 'package:shop_list/ui/home/widget/custom_drawer_header.dart';
import 'package:shop_list/ui/home/widget/drawer_item.dart';
import 'package:shop_list/ui/login/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginController = context.read<LoginController>();

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDrawerHeader(),
              StreamBuilder<LoginState>(
                stream: loginController.outLoginState,
                builder: (context, state) {
                  if(state.hasData){
                    if(state.data!.state == stateLogin.LOGGED){
                      return DrawerItem(
                        title: 'Sair',
                        icon: FaIcon(
                          FontAwesomeIcons.signOutAlt,
                        ),
                        onTap: () async {
                          bool _success = await loginController.logOut();
                          if (_success) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                      );
                    }
                  }
                  return Container();
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
