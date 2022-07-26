import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/login_controller.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/shared/constants.dart';
import 'package:shop_list/shared/widget/user_photo.dart';
import 'package:shop_list/ui/home/drawer/custom_drawer.dart';
import 'package:shop_list/ui/home/widget/my_shopLists_widget.dart';
import 'package:shop_list/ui/home/widget/shared_shopLists_widget.dart';
import 'widget/create_list_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final loginController = Get.find<LoginController>();
  final shopListController = Get.put(ShopListController());
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController pageController;
  bool myList = true;

  @override
  void initState() {
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );

    if (index == 0) {
      myList = true;
    } else {
      myList = false;
    }

    setState(() {});
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
            Icons.menu_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("ShopList", 
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [UserPhotoWidget()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        onPageChanged(0);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: myList ? thirdColor : Colors.transparent,
                        border: myList
                            ? null
                            : Border.all(color: Colors.grey, width: 0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        "Minhas listas",
                        style: TextStyle(
                            color: myList ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        onPageChanged(1);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: !myList ? thirdColor : Colors.transparent,
                        border: !myList
                            ? null
                            : Border.all(color: Colors.grey, width: 0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        "Listas compartilhadas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !myList ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  MyShopListsWidget(),
                  SharedShopListsWidget(),
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
