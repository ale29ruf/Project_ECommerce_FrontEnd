import 'ProductInPurchase.dart';

class Purchase{
  int? id;
  String? date;
  String? time;
  List<ProductInPurchase>? productsInPurchase;
  String? message;

  Purchase({this.id, this.date, this.time, this.productsInPurchase, this.message});

  factory Purchase.fromJson(Map<String, dynamic> mappa) {
    if(mappa.containsKey('message')){
      return Purchase(message: mappa['message']);
    }
    //List<ProductInPurchase> list = List<ProductInPurchase>.from(mappa['productsInPurchase'].map((i) => ProductInPurchase.fromJson(i)).toList());
    //List<ProductInPurchase> list = List<ProductInPurchase>.from(jsonDecode(mappa['productsInPurchase']).map((i) => ProductInPurchase.fromJson(i)).toList());
    List<ProductInPurchase> list = List<ProductInPurchase>.from(mappa['productsInPurchase'].map((i) => ProductInPurchase.fromJson(i)).toList());
    int valueTime = mappa['purchaseTime'];
    DateTime dataTime = DateTime.fromMillisecondsSinceEpoch(valueTime);
    List<String> split = dataTime.toString().split(" ");
    Purchase purchase = Purchase(id: mappa['id'], date: split[0], time: split[1], productsInPurchase: list);
    return purchase;
  }

  bool hasError(){
    return message != null;
  }

  @override
  String toString() {
    return "Id (da mostrare all'assistenza nel caso di problemi): $id, \nOra: ${getTime()}, \nGiorno: $date, \n\nProdotti acquistati: $productsInPurchase";
  }

  String getTime() {
    List<String> parts = time!.split('.'); /// Cosi' facendo fermiamo la stampa del tempo fino ai secondi
    return parts[0];
  }

}