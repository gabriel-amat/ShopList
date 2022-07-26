import 'package:flutter/material.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/constants.dart';

class AddItemWidget extends StatefulWidget {
  final ShopListModel list;
  final Function(ItemModel) onSubmit;

  AddItemWidget({required this.list, required this.onSubmit});

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final _name = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onAddTap() {
    if (_formKey.currentState!.validate()) {
      ItemModel _newItem = ItemModel(checked: false, name: _name.text);
      _name.clear();
      widget.onSubmit(_newItem);
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
          topRight: Radius.circular(10),
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
      child: Row(
        children: [
          Flexible(
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: 45,
                child: TextFormField(
                  controller: _name,
                  onFieldSubmitted: (String? value){
                    onAddTap();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Nome',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: onAddTap,
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
