import 'package:flutter/material.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/widget/notifications.dart';

class CreateListWidget extends StatefulWidget {
  @override
  _CreateListWidgetState createState() => _CreateListWidgetState();
}
class _CreateListWidgetState extends State<CreateListWidget> {

  final notification = CustomNotification();
  ShopListController? _shopListController;
  final _title = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _shopListController = context.read<ShopListController>();
    super.initState();
  }

  Future<void> onAddTap() async {
    if(_formKey.currentState!.validate()){
      
      var _data = ShopListModel(
        name: _title.text
      );
      
      bool success = await _shopListController!.createList(_data);

      if(!success){
        notification.showSnackErrorWithIcon(text: "Erro ao criar lista");
      }

      _title.clear();
      FocusScope.of(context).unfocus();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _title,
              validator: (value){
                if(value!.isEmpty){
                  return 'De um nome a sua lista';
                }else{
                  return null;
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                hintText: 'Crie uma nova lista...'
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
              child: Text("Criar"),
            ),
          )
        ],
      ),
    );
  }
}
