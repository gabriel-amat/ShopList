import 'package:flutter/material.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/controller/login/login_state.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/shared/app_text_style.dart';
import 'package:shop_list/shared/widget/user_photo.dart';
import 'package:shop_list/ui/home/widget/custom_drawer.dart';
import 'package:shop_list/ui/myList/my_list_screen.dart';
import 'widget/create_list_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  LoginController? loginController;
  ShopListController? shopListController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _getData() async {
    if(loginController!.loginState.value.state == stateLogin.LOGGED){
      shopListController!.getAllShopListsFromFirebase();
    }else{
      shopListController!.getLocallyLists();
    }
  }

  @override
  void initState() {
    shopListController = context.read<ShopListController>();
    loginController = context.read<LoginController>();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          UserPhotoWidget()
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
                  Text("Listas de compras", style: AppTextStyle.title),
                  SizedBox(height: 16,),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Consumer<ShopListController>(
                      builder: (context, shop, child) {
                        return shop.shopList.length > 0 ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: shop.shopList.length,
                          itemBuilder: (context, index) {
                            var _item = shop.shopList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) =>
                                        MyListScreen(list: _item),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 2,
                                  child: Container(
                                    child: ListTile(
                                      title: Text(_item.name!,
                                          style: AppTextStyle.normalText),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ) : Center(
                          child: Text(
                              "Clique no botão abaixo para criar sua primeira lista.",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.normalText),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          CreateListWidget(),
        ],
      ),
    );
  }
}
