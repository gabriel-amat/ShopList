import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/widget/notifications.dart';

class CreateListWidget extends StatefulWidget {
  @override
  _CreateListWidgetState createState() => _CreateListWidgetState();
}
class _CreateListWidgetState extends State<CreateListWidget> {

  final notification = CustomNotification();
  final shopListController = Get.find<ShopListController>();
  final title = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> onAddTap() async {
    if(_formKey.currentState!.validate()){
      
      var _data = ShopListModel(
        name: title.text
      );
      
      bool success = await shopListController.createList(_data);

      if(!success){
        notification.error(text: "Erro ao criar lista");
      }

      title.clear();
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
      child: Row(
        children: [
          Flexible(
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: 45,
                child: TextFormField(
                  controller: title,
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
            ),
          ),
          const SizedBox(width: 16,),
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
