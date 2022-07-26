import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_list/models/user/user_model.dart';
import 'package:shop_list/shared/widget/notifications.dart';

class UserService {
  
  final db = FirebaseFirestore.instance;
  final snack = CustomNotification();

  Future<UserModel?> getUserById(String id) async {
    try {
      DocumentSnapshot doc = await db.collection("users").doc(id).get();
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (error) {
      snack.error(text: "Erro ao buscar dados deste usuario $error");
      return null;
    }
  }
}
