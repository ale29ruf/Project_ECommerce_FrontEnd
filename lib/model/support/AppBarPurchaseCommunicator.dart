import 'package:project_ecommerce/model/Model.dart';

import '../objects/Purchase.dart';

class AppBarPurchaseCommunicator{
  static const int PURCHASE_FOR_PAGE = 5; /// Numero di acquisti da far visualizzare su singola pagina
  late List<Purchase> purchases;
  late int lastIndex = -1;

  static AppBarPurchaseCommunicator sharedInstance = AppBarPurchaseCommunicator();

  Future<List<Purchase>?> getPurchase(int i) async {
    if(lastIndex == i) {
      return purchases;
    }
    lastIndex = i;
    purchases = (await Model.sharedInstance.getPurchase(i, PURCHASE_FOR_PAGE))!;
    return purchases;
  }



}