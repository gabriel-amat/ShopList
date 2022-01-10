import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/app_text_style.dart';
import 'widget/add_item_widget.dart';

class MyListScreen extends StatefulWidget {

  final ShopListModel list;

  MyListScreen({required this.list});

  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {

  ShopListController? _controller;
  List<ItemModel> _items = [];

  var _listTitle = TextEditingController();

  @override
  void initState() {
    _controller = context.read<ShopListController>();
    _items = widget.list.products!;
    super.initState();
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
                    borderRadius: BorderRadius.circular(10)
                )
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.red
              ),
              child: Text('cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                )
              ),
              child: Text('editar'),
              onPressed: () {
                _controller!.editListName(
                  list: widget.list,
                  name: _listTitle.text
                );
                setState(() {});
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void handleClick(BuildContext context, String value) {
    switch (value) {
      case 'Editar nome':
        showDialogEditNome(context);
        break;
      case 'Deletar':
        _controller!.deleteList(widget.list);
        setState(() {});
        Navigator.of(context).pop();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.list.name!),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => handleClick(context, value),
            itemBuilder: (BuildContext context) {
              return {'Editar nome', 'Deletar'}.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Itens", style: AppTextStyle.title),
                  SizedBox(height: 16),
                  Flexible(
                    fit: FlexFit.loose,
                    child: _items.length > 0 ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: ListTile(
                            title: Text(_items[index].name!,
                              style: TextStyle(
                                decoration: _items[index].checked!
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: _items[index].checked!
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _items[index].checked,
                                  activeColor: Colors.green,
                                  onChanged: (newValue) {
                                    _controller!.checkItem(
                                      value: newValue!,
                                      item: _items[index],
                                      list: widget.list,
                                    );
                                    if (newValue) {
                                      //Altera a ordem, vai pro final
                                      final ItemModel item = _items.removeAt(index);
                                      _items.add(item);
                                    }
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    _controller!.deleteItem(
                                        item: _items[index],
                                        list: widget.list
                                    );
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ) : Center(
                      child: Text("Começe a adicionar novos itens.",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.normalText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AddItemWidget(
            list: widget.list,
            newItem: (item) {
              _controller!.addItemToShopList(item: item, list: widget.list,);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
