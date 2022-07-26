import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/list_user_controller.dart';
import 'package:shop_list/controller/share_controller.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'widget/list_share_tile.dart';

class ListShareScreen extends StatefulWidget {
  final ShopListModel list;

  const ListShareScreen({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<ListShareScreen> createState() => _ListShareScreenState();
}

class _ListShareScreenState extends State<ListShareScreen> {
  final listUserControll = Get.find<ListUserController>();
  final shareController = Get.find<ShareController>();
  final snack = CustomNotification();

  @override
  void initState() {
    listUserControll.getUsersData(widget.list);
    super.initState();
  }

  Future<void> update() async {
    var res = await listUserControll.getListById(widget.list.id!);
    if(res == null){
      snack.error(text: "Erro ao atualizar dados de acesso.");
      return;
    }
    await listUserControll.getUsersData(res);
  }

  Widget empty() {
    return Center(
      child: Text("Nenhum usuário nessa lista."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: Text(widget.list.name!),
          bottom: TabBar(
            indicatorColor: secondColor,
            tabs: [
              Tab(
                text: "Liberados",
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
              ),
              Tab(
                text: "Pendentes",
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.pending_actions_rounded,
                    color: Colors.orange,
                  ),
                ),
              ),
              Tab(
                text: "Bloqueados",
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.block,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              var users = listUserControll.userWithAccess;

              if (users.isEmpty) return empty();

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListShareTile(
                    user: users[index],
                    onTapSecondOption: () async {
                      await shareController.blockUser(
                        widget.list.id!,
                        users[index].id!,
                      );
                      
                      update();
                    },
                  );
                },
              );
            }),
            Obx(() {
              var users = listUserControll.userWithAccessPending;

              if (users.isEmpty) return empty();

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListShareTile(
                    user: users[index],
                    onTapFirstOption: () async {
                      await shareController.acceptUser(
                        widget.list.id!,
                        users[index].id!,
                      );

                      await listUserControll.getUsersData(widget.list);
                    },
                    onTapSecondOption: () async {
                      await shareController.declineUser(
                        widget.list.id!,
                        users[index].id!,
                      );

                      update();
                    },
                  );
                },
              );
            }),
            Obx(() {
              var users = listUserControll.userWithAccessDenied;

              if (users.isEmpty) return empty();

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListShareTile(
                    user: users[index],
                    onTapFirstOption: () async {
                      await shareController.unBlockUser(
                        widget.list.id!,
                        users[index].id!,
                      );
                      update();
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
