import 'package:project_ecommerce/model/Model.dart';

import '../objects/Purchase.dart';

class AppBarPurchaseCommunicator{
  static const int PURCHASE_FOR_PAGE = 5; /// Numero di acquisti da far visualizzare su singola pagina
  late List<Purchase> purchases = [];
  late Function refresh;

  static AppBarPurchaseCommunicator sharedInstance = AppBarPurchaseCommunicator();

  Future<List<Purchase>?> getPurchase(int i) async {
    purchases = (await Model.sharedInstance.getPurchase(i, PURCHASE_FOR_PAGE))!;
    return purchases;
  }

  Future<List<Purchase>?> getPurchaseInTime(String start, String end) async {
    List<Purchase> tmp = (await Model.sharedInstance.getPurchaseInTime(start,end))!;
    purchases.clear();
    purchases.addAll(tmp);
    refresh.call();
    return purchases;
  }

  void addRefresh(Function() refresh) {
    this.refresh = refresh;
  }

}