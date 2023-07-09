import 'package:project_ecommerce/model/Model.dart';

import '../objects/Purchase.dart';

class AppBarPurchaseCommunicator{
  static const int PURCHASE_FOR_PAGE = 5; /// Numero di acquisti da far visualizzare su singola pagina
  late List<Purchase> purchases = [];

  static AppBarPurchaseCommunicator sharedInstance = AppBarPurchaseCommunicator();

  Future<List<Purchase>?> getPurchase(int i) async {
    purchases = (await Model.sharedInstance.getPurchase(i, PURCHASE_FOR_PAGE))!;
    return purchases;
  }

}