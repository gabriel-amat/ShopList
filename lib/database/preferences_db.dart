import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_list/models/shop/shop_list_model.dart';

class PreferencesDB{

  //This make the class a singleton - a unique instance for whole project
  static final PreferencesDB instance = PreferencesDB._init();
  PreferencesDB._init();

  Future storeMyLists(List<ShopListModel> data) async{
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = ShopListModel.encode(data);
    await prefs.setString('shop_lists', encodedData);
  }

  Future<List<ShopListModel>> getMyLists() async{
    final prefs = await SharedPreferences.getInstance();
    final String? shopListsAsString = prefs.getString('shop_lists');
    if(shopListsAsString != null){
      return ShopListModel.decode(shopListsAsString);
    }else{
      return [];
    }
  }


}