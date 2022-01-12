import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'package:shop_list/ui/myList/widget/product_item.dart';
import 'widget/add_item_widget.dart';

class MyListScreen extends StatefulWidget {
  final ShopListModel list;

  MyListScreen({required this.list});

  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  
  ShopListController? _controller;
  var _listTitle = TextEditingController();
  final notification = CustomNotification();

  @override
  void initState() {
    super.initState();
    _controller = context.read<ShopListController>();
    _getListData();
  }

  Future<void> _getListData() async {
    await _controller!.getList(widget.list.id!);
  }

  void addItem(ItemModel item) async {
    bool success = await _controller!.addItem(item: item, listId: widget.list.id!);
    if(!success){
      notification.showSnackErrorWithIcon(text: "Erro ao adicionar item, se persisitir contate um administrador");
    }
  }

  Future<void> updateListInfo(BuildContext dialogContext) async {
    widget.list.name = _listTitle.text;
    bool success = await _controller!.updateShopList(widget.list);

    if(!success){
      notification.showSnackErrorWithIcon(text: "Erro ao atualizar lista, se persistir contate um administrador");
    }

    Navigator.of(dialogContext, rootNavigator: true).pop();
  }

  void showDialogEditNome(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
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
                Navigator.of(dialogContext, rootNavigator: true).pop();
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

  void handleClick(BuildContext context, String value) async {
    switch (value) {
      case 'Editar nome':
        showDialogEditNome(context);
        break;
      case 'Deletar':
        bool success = await _controller!.deleteShopList(widget.list.id!);
        if(!success){
          notification.showSnackErrorWithIcon(text: "Erro ao excluir lista, se persistir contate um administrador");
        }else{
          Navigator.pop(context);
        }
        break;
    }
  }

  Widget _emptyList() {
    return Center(
      child: Text(
        "Começe a adicionar novos itens.",
        textAlign: TextAlign.center,
        style: AppTextStyle.normalText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<ShopListModel?>(
          stream: _controller!.outList,
          builder: (context, list) {
            if(list.hasData){
              return Text(list.data!.name!);
            }else{
              return Text("Lista de compras");
            }
          }
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => handleClick(context, value),
            itemBuilder: (BuildContext context) {
              return {'Editar nome', 'Deletar'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: StreamBuilder<ShopListModel?>(
          stream: _controller!.outList,
          builder: (context, list) {
            if (!list.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (list.data!.products == null || list.data!.products!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  _emptyList(),
                  AddItemWidget(
                    list: widget.list,
                    newItem: (ItemModel item) => addItem(item),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Itens", style: AppTextStyle.title),
                          SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.data!.products!.length,
                            itemBuilder: (context, index) {
                              return ProductItem(
                                controller: _controller!, 
                                item: list.data!.products![index],
                                listData: list.data!,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  AddItemWidget(
                    list: widget.list,
                    newItem: (ItemModel item) => addItem(item),
                  ),
                ],
              );
            }
          }),
    );
  }
}
