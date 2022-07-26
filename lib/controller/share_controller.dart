import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/service/share_service.dart';
import 'package:shop_list/shared/preferences.dart';
import 'package:shop_list/shared/widget/notifications.dart';

class ShareController extends GetxController {
  final dynamicLink = FirebaseDynamicLinks.instance;
  final shareService = ShareService();
  final notifications = CustomNotification();

  @override
  void onReady() {
    super.onReady();
    listenDynamicLinks();
  }

  listenDynamicLinks() {
    dynamicLink.onLink.listen((data) => receiveShareLink(data));
  }

  Future<Uri> createShareLink(ShopListModel list) async {
    var uriComponents = Uri(
      scheme: "https",
      host: "myshoplist.page.link",
      queryParameters: {
        "listID": list.id,
        "listTitle": list.name,
        "thumb": list.thumb,
        "listCreatorName": list.creator?.name,
        "listCreatorPhoto": list.creator?.photo,
      },
    );

    final dynamicLinkParams = DynamicLinkParameters(
      link: uriComponents,
      uriPrefix: "https://myshoplist.page.link/",
      androidParameters: const AndroidParameters(
        packageName: "com.example.shop_list",
      ),
    );

    return await dynamicLink.buildLink(dynamicLinkParams);
  }

  Future receiveShareLink(PendingDynamicLinkData? link) async {
    print("Received new link! $link");
    if (link == null) return;

    String? userId = await MySharedPreferences.getUserId();

    if (userId == null) return;

    notifications.receiveLinkDialog(link.link.queryParameters);

    // await shareService.enterPendingList(
    //   link.utmParameters["listId"]!,
    //   userId,
    // );
  }

  Future enterListAsPendingUser(String listId) async {
    String? myId = await MySharedPreferences.getUserId();

    if (myId == null) return;

    await shareService.enterPendingList(listId, myId);
  }

  Future<void> acceptUser(String listId, String userId) async {
    await shareService.acceptUser(listId, userId);
  }

  Future<void> declineUser(String listId, String userId) async {
    await shareService.declineUser(listId, userId);
  }

  Future<void> blockUser(String listId, String userId) async {
    await shareService.blockUser(listId, userId);
  }

  Future<void> unBlockUser(String listId, String userId) async {
    await shareService.unBlockUser(listId, userId);
  }
}
