import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';
import 'package:shop_list/shared/widget/notifications.dart';

class ShareService {
  final db = FirebaseFirestore.instance;
  final snack = CustomNotification();

  Future<void> enterPendingList(String listId, String myId) async {
    try {
      DocumentSnapshot doc = await db.collection("lists").doc(listId).get();

      ShopListModel listData = ShopListModel.fromJson(
        doc.data() as Map<String, dynamic>,
      );

      if (listData.creatorId == myId) {
        snack.error(text: "Você é o dono desta lista.");
        return;
      }

      if (listData.access!.contains(myId)) {
        snack.warning(text: "Você já faz parte desta lista.");
        return;
      }

      if (listData.accessPending!.contains(myId)) {
        snack.warning(text: "Seu pedido ainda está pendente.");
        return;
      }

      if (listData.accessDenied!.contains(myId)) {
        snack.error(text: "Seu acesso á esta lista foi negado.");
        return;
      }

      await db.collection("lists").doc(listId).update({
        "accessPending": FieldValue.arrayUnion([myId])
      });

      snack.success(
        text:
            "Sucesso, agora é só esperar aceitarem seu pedido para entrar na lista.",
      );
    } catch (error) {
      snack.error(text: "Erro ao entrar nessa lista, $error");
    }
  }

  Future<void> acceptUser(String listId, String userId) async {
    try {
      final DocumentReference ref = db.collection("lists").doc(listId);

      await ref.update({
        "accessPending": FieldValue.arrayRemove([userId])
      });

      await ref.update({
        "access": FieldValue.arrayUnion([userId])
      });

      snack.success(text: "Usuário adicionado com succeso");
    } catch (error) {
      snack.error(text: "Erro ao adicionar usuario nessa lista, $error");
    }
  }

  Future<void> declineUser(String listId, String userId) async {
    try {
      final DocumentReference ref = db.collection("lists").doc(listId);

      await ref.update({
        "accessPending": FieldValue.arrayRemove([userId])
      });

      await ref.update({
        "accessDenied": FieldValue.arrayUnion([userId])
      });

      snack.success(text: "Usuário bloqueado desta lista.");
    } catch (error) {
      snack.error(text: "Erro ao bloquear usuario nessa lista, $error");
    }
  }

  Future<void> blockUser(String listId, String userId) async {
    try {
      final DocumentReference ref = db.collection("lists").doc(listId);

      await ref.update({
        "access": FieldValue.arrayRemove([userId])
      });

      await ref.update({
        "accessDenied": FieldValue.arrayUnion([userId])
      });

      snack.success(text: "Usuário bloqueado.");
    } catch (error) {
      snack.error(text: "Erro ao bloquear usuario nessa lista, $error");
    }
  }

  Future<void> unBlockUser(String listId, String userId) async {
    try {
      final DocumentReference ref = db.collection("lists").doc(listId);

      await ref.update({
        "accessDenied": FieldValue.arrayRemove([userId])
      });

      await ref.update({
        "access": FieldValue.arrayUnion([userId])
      });

      snack.success(text: "Usuário desbloqueado.");
    } catch (error) {
      snack.error(text: "Erro ao desbloquear usuario nessa lista, $error");
    }
  }
}
