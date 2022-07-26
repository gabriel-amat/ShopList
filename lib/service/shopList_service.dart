import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_list/models/shop/item_model.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/preferences.dart';
import 'package:shop_list/shared/widget/notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/file_picked_model.dart';

class ShopListService {
  final storage = FirebaseStorage.instance;
  final _db = FirebaseFirestore.instance;
  final snack = CustomNotification();
  var uuid = Uuid();

  Stream<List<ShopListModel>> listStream(String userId) => _db
          .collection("lists")
          .where("creatorId", isEqualTo: userId)
          .snapshots(includeMetadataChanges: true)
          .map(
        (event) {
          List<ShopListModel> list = [];
          for (var e in event.docs) {
            final listModel = ShopListModel.fromJson(e.data());
            list.add(listModel);
          }
          return list;
        },
      ).handleError((error) {
        print("Error while listen lists $error");
        return [];
      });

  Stream<List<ShopListModel>> sharedListStream(String userId) => _db
          .collection("lists")
          .where("access", arrayContains: userId)
          .snapshots(includeMetadataChanges: true)
          .map(
        (event) {
          List<ShopListModel> list = [];
          for (var e in event.docs) {
            final listModel = ShopListModel.fromJson(e.data());
            list.add(listModel);
          }
          return list;
        },
      ).handleError((error) {
        print("Error while listen shared lists $error");
        return [];
      });

  Future<bool> createList({
    required ShopListModel data,
    FilePickedModel? thumb,
  }) async {
    String? userId = await MySharedPreferences.getUserId();

    if (userId == null) return false;

    try {
      final ref = _db.collection("lists").doc();

      if (thumb != null) {
        data.thumb = await saveListThumb(thumb, ref.id);
      }

      data.id = ref.id;
      await ref.set(data.toJson());

      return true;
    } catch (e) {
      print("Erro ao criar shopList $e");
      return false;
    }
  }

  Future<bool> updateList(
    ShopListModel data, {
    FilePickedModel? thumb,
  }) async {
    String? _id = await MySharedPreferences.getUserId();

    if (_id != null) {
      try {
        DocumentReference ref = _db.collection("lists").doc(data.id);

        if (data.thumb != null && thumb != null) {
          await deleteListThumb(data.thumb!);
        }

        if (thumb != null) {
          data.thumb = await saveListThumb(thumb, ref.id);
        }

        await ref.update(data.toJson());

        return true;
      } catch (e) {
        print("Erro ao editar item $e");
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteList({required ShopListModel list}) async {
    String? _id = await MySharedPreferences.getUserId();

    if (_id == null) return false;

    try {
      if (list.thumb != null) {
        if (list.thumb!.isNotEmpty) {
          await deleteListThumb(list.thumb!);
        }
      }

      await _db.collection("lists").doc(list.id).delete();
      return true;
    } catch (e) {
      print("Erro ao excluir $e");
      return false;
    }
  }

  Future<bool> updateItem({
    required List<ItemModel> itens,
    required String listId,
    required String userId,
  }) async {
    try {
      await _db
          .collection("lists")
          .doc(listId)
          .update({"products": itens.map((e) => e.toJson()).toList()});
      return true;
    } catch (e) {
      snack.error(text: "Erro ao editar item, $e");
      return false;
    }
  }

  Future<bool> deleteItemFromList({
    required ItemModel item,
    required String listId,
  }) async {
    String? _id = await MySharedPreferences.getUserId();

    if (_id != null) {
      try {
        await _db.collection("lists").doc(listId).update({
          "products": FieldValue.arrayRemove([item.toJson()])
        });

        return true;
      } catch (e) {
        print("Erro ao excluir item $e");
        return false;
      }
    }
    return false;
  }

  Future<bool> addItemToList({
    required ItemModel item,
    required String listId,
  }) async {
    String? _id = await MySharedPreferences.getUserId();

    if (_id != null) {
      try {
        item.id = uuid.v4();

        await _db.collection("lists").doc(listId).update({
          "products": FieldValue.arrayUnion([item.toJson()])
        });

        return true;
      } catch (e) {
        print("Erro ao adicionar item $e");
        return false;
      }
    }
    return false;
  }

  Future<ShopListModel?> getListById(String id) async {
    try {
      var res = await _db.collection("lists").doc(id).get();
      return ShopListModel.fromJson(res.data() as Map<String, dynamic>);
    } catch (error) {
      return null;
    }
  }

  Future<bool> deleteListThumb(String url) async {
    try {
      Reference _ref = storage.refFromURL(url);
      await _ref.delete();
      return true;
    } catch (e) {
      print("Erro ao deletar foto da lista $e");
      return false;
    }
  }

  Future<String?> saveListThumb(
    FilePickedModel file,
    String listId,
  ) async {
    try {
      var url;
      Reference _reference = storage.ref().child(
            'lists/$listId/${file.name}',
          );

      await _reference
          .putData(file.bytes, SettableMetadata(contentType: file.contentType))
          .whenComplete(() async {
        url = await _reference.getDownloadURL();
      });
      return url;
    } catch (e) {
      print("Erro ao salvar imagem $e");
      return null;
    }
  }
}
