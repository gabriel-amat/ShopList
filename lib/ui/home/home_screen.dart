import 'package:flutter/material.dart';
import 'package:shop_list/controller/login/login_controller.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/theme/app_text_style.dart';
import 'package:shop_list/shared/widget/user_photo.dart';
import 'package:shop_list/ui/home/widget/custom_drawer.dart';
import 'package:shop_list/ui/home/widget/list_item.dart';
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

  @override
  void initState() {
    super.initState();
    shopListController = context.read<ShopListController>();
    loginController = context.read<LoginController>();
    _getData();
  }

  void _getData() async {
    shopListController!.getAllLists(true);
  }

  Widget _emptyList(){
    return Center(
      child: Column(
        children: [
          Icon(Icons.list_rounded, size: 50, color: Colors.grey,),
          const SizedBox(height: 5),
          Text("Você ainda não tem nenhuma lista",
            style: TextStyle(
              fontWeight: FontWeight.w300
            ),
          )
        ],
      ),
    );
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
                    child: StreamBuilder<List<ShopListModel>?>(
                      stream: shopListController!.outShopLists,
                      builder: (_, list){
                        if(list.hasData && list.data!.isNotEmpty){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.data!.length,
                            itemBuilder: (context, index) {
                              return ListItem(list: list.data![index]);
                            },
                          );
                        }
                        return _emptyList();
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
