import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_list/controller/share_controller.dart';
import 'package:shop_list/shared/constants.dart';

class CustomNotification {
  void showFCMNotifications({
    required BuildContext context,
    required String body,
    required String title,
  }) {
    Get.defaultDialog(
      title: title,
      content: Text(body),
      radius: 10,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Ok"),
        )
      ],
    );
  }

  void cancel() => Get.closeCurrentSnackbar();

  void error({required String text, int? duration}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      "Oops",
      text,
      margin: const EdgeInsets.all(16),
      duration: Duration(seconds: duration ?? 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 10,
      icon: Icon(
        Icons.error,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  void success({required String text, IconData? icon, int? duration}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      "Nice",
      text,
      duration: Duration(seconds: duration ?? 3),
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(16),
      colorText: Colors.white,
      borderRadius: 10,
      icon: Icon(
        Icons.check_circle,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  void warning({required String text, IconData? icon, int? duration}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      "Aviso",
      text,
      duration: Duration(seconds: duration ?? 3),
      backgroundColor: Colors.orange,
      margin: const EdgeInsets.all(16),
      colorText: Colors.white,
      borderRadius: 10,
      icon: Icon(
        Icons.warning_amber_rounded,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  void loading({required String text, IconData? icon}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.snackbar(
      "Aguarde um instante",
      "Carregando",
      margin: const EdgeInsets.all(16),
      backgroundColor: Colors.orange,
      showProgressIndicator: true,
      progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(secondColor),
      progressIndicatorBackgroundColor: thirdColor,
      colorText: Colors.white,
      borderRadius: 10,
    );
  }

  void receiveLinkDialog(Map<String, dynamic> parameters) {
    var shareController = Get.find<ShareController>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            parameters["thumb"] == ""
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        parameters["listTitle"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    height: 75,
                    width: double.maxFinite,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            parameters["thumb"]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Text(
                            parameters["listTitle"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                "${parameters["listCreatorName"]} convidou você para entrar nesta lista!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      await shareController.enterListAsPendingUser(
                        parameters["listID"]!,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
