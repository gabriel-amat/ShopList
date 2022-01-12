import 'package:flutter/material.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';

class AddItemWidget extends StatefulWidget {

  final ShopListModel list;
  final Function(ItemModel) newItem;

  AddItemWidget({required this.list, required this.newItem});

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {

  final _name = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onAddTap(){
    if(_formKey.currentState!.validate()){
      ItemModel _newItem = ItemModel(
          checked: false,
          name: _name.text
      );
      _name.clear();
      widget.newItem(_newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _name,
              validator: (value){
                if(value!.isEmpty){
                  return 'Digite o nome do item';
                }else{
                  return null;
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                hintText: 'Nome do item'
              ),
            ),
          ),
          SizedBox(height: 16,),
          Container(
            height: 40,
            child: ElevatedButton(
              onPressed: onAddTap,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              child: Text("Adicionar item"),
            ),
          )
        ],
      ),
    );
  }
}
