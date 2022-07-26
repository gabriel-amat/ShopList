import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/share_controller.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/preferences.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'package:shop_list/ui/myList/list_share_screen.dart';
import 'package:shop_list/ui/myList/thumb/dialog_chose_image.dart';

class CustomAppbar extends StatefulWidget {
  final ShopListModel list;

  CustomAppbar({required this.list});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  final shareController = Get.find<ShareController>();
  final shopListController = Get.find<ShopListController>();
  final snack = CustomNotification();
  var _listTitle = TextEditingController();
  bool amICreator = true;
  bool showThumb = false;
  final popUpOptions = [
    'Editar nome',
    'Acessos',
    'Alterar capa',
    'Deletar',
  ];

  @override
  void initState() {
    checkCreator();
    super.initState();
  }

  Future<void> coppyToClipboard(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
    snack.success(text: "Texto copiado para a área de transferência.");
  }

  Future<void> checkCreator() async {
    var userId = await MySharedPreferences.getUserId();

    if (userId == null) {
      amICreator = false;
      return;
    }

    amICreator = shopListController.amICreator(widget.list, userId);
  }

  void showShareDialog(String link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 65,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Seu link esta pronto para ser compartilhado!!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: thirdColor,
              ),
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  coppyToClipboard(link);
                },
                child: Text(
                  link,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("ok"),
          )
        ],
      ),
    );
  }

  Future<void> updateListInfo(BuildContext dialogContext) async {
    setState(() {
      widget.list.name = _listTitle.text;
    });
    bool success = await shopListController.updateShopList(widget.list);

    if (!success) {
      snack.error(
        text: "Erro ao atualizar lista, se persistir contate um administrador",
      );
    }
    Get.back();
  }

  void showDialogEditNome(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Editar nome'),
          content: TextFormField(
            autofocus: true,
            controller: _listTitle,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Insira um nome valido';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Novo nome',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: Colors.red),
              child: Text('cancelar'),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('editar'),
              onPressed: () => updateListInfo(dialogContext),
            ),
          ],
        );
      },
    );
  }

  void handlePopupClick(BuildContext context, String value) async {
    switch (value) {
      case 'Acessos':
        Get.to(
          ListShareScreen(
            list: widget.list,
          ),
        );
        break;
      case 'Alterar capa':
        Get.dialog(
          DialogChoseImage(
            list: widget.list,
          ),
        );
        break;
      case 'Editar nome':
        showDialogEditNome(context);
        break;
      case 'Deletar':
        if (!amICreator) {
          snack.error(text: "Você não tem permissão para excluir esta lista.");
          return;
        }

        Get.dialog(AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Certeza que deseja excluir esta lista?",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                bool success = await shopListController.deleteShopList(
                  widget.list,
                );
                print("Delete $success");
                if (!success) {
                  snack.error(text: "Erro ao excluir lista.");
                }
                snack.success(text: "Lista deletada.");
                Get.back(closeOverlays: true);
              },
              child: Text(
                "Excluir",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ));

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    showThumb = widget.list.thumb == null || widget.list.thumb!.isEmpty;

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          showThumb
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                     borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.dstATop,
                      ),
                      image: NetworkImage(widget.list.thumb!),
                    ),
                  ),
                ),
          Positioned(
            bottom: 10,
            left: 16,
            child: Text(
              widget.list.name!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          Uri res = await shareController.createShareLink(
                            widget.list,
                          );
                          await Clipboard.setData(
                            ClipboardData(text: res.toString()),
                          );
                          var newString = res
                              .toString()
                              .replaceRange(70, res.toString().length, '...');
                          showShareDialog(newString);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: thirdColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.share_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: thirdColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                          ),
                          onSelected: (value) =>
                              handlePopupClick(context, value),
                          itemBuilder: (BuildContext context) {
                            return popUpOptions.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
