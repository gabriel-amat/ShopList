import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shop_list/controller/shop_list_controller.dart';
import 'package:shop_list/models/file_picked_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/helper/get_file_type.dart';
import 'package:shop_list/shared/widget/notifications.dart';

class DialogChoseImage extends StatefulWidget {
  final ShopListModel list;
  final bool allowImages;
  final bool allowPdf;

  const DialogChoseImage({
    Key? key,
    required this.list,
    this.allowImages = true,
    this.allowPdf = false,
  }) : super(key: key);

  @override
  _DialogChoseImageState createState() => _DialogChoseImageState();
}

class _DialogChoseImageState extends State<DialogChoseImage> {
  final shopListController = Get.find<ShopListController>();
  final snack = CustomNotification();
  FilePickedModel? fileSelected;

  // Future<void> removeImage(Function buildSetState) async {
  //   buildSetState(() => fileSelected = null);
  //   shopListController.thumb = null;
  //   await shopListController.updateShopList(widget.list);
  // }

  List<String> extensions() {
    List<String> _extensions = [];

    if (widget.allowImages) {
      _extensions.addAll(['jpeg', 'jpg', 'png']);
    }

    if (widget.allowPdf) {
      _extensions.add('pdf');
    }

    return _extensions;
  }

  Future<void> chooseImage(Function buildSetState) async {
    FilePickerResult? res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions(),
      withData: true,
    );

    if (res == null) {
      snack.error(text: "Erro ao selecionar imagem.");
      return;
    }

    Uint8List? bytes = res.files.first.bytes;
    PlatformFile file = res.files.first;

    if (bytes == null) {
      snack.error(text: "Erro: Imagem sem bytes");
      return;
    }

    buildSetState(() {
      fileSelected = FilePickedModel(
        bytes,
        Path.basenameWithoutExtension(res.files.single.name),
        getFileType(file.extension!),
      );
    });

    shopListController.thumb = fileSelected!;
  }

  Future<void> saveChanges() async {
    Get.back();
    snack.loading(text: "Carregando imagem");
    bool res = await shopListController.updateShopList(widget.list);
    if (res) {
      snack.success(text: "Foto de capa alterada");
    } else {
      snack.error(text: "Erro ao alterar foto de capa");
    }
  }

  Widget noImage() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.file_present_rounded,
        color: Colors.white,
        size: 35,
      ),
    );
  }

  Widget imageSelected() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.memory(
        Uint8List.fromList(fileSelected!.bytes),
        fit: BoxFit.cover,
        height: 150,
        width: 150,
      ),
    );
  }

  Widget image() {
    if (widget.list.thumb != null && fileSelected == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          widget.list.thumb!,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    }

    if (fileSelected == null) return noImage();

    return imageSelected();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, buildSetState) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Foto de capa",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              image(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flexible(
                  //   flex: 1,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       primary: Colors.red,
                  //     ),
                  //     onPressed: () => removeImage(buildSetState),
                  //     child: Text("Remover"),
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Colors.blue,
                      ),
                      onPressed: () => chooseImage(buildSetState),
                      child: Text(
                        "Selecionar imagem",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  fileSelected == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Flexible(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  primary: Colors.green),
                              onPressed: saveChanges,
                              child: Text(
                                "Salvar alterações",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
