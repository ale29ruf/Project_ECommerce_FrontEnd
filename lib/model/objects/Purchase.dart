import 'ProductInPurchase.dart';
import 'ProductInPurchase.dart';
import 'dart:convert';

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
    //List<ProductInPurchase> list = List<ProductInPurchase>.from(jsonDecode(json['productsInPurchase']).map((i) => ProductInPurchase.fromJson(i)).toList());
    List<ProductInPurchase> list = List<ProductInPurchase>.from(json.decode(mappa['productsInPurchase']).map((i) => ProductInPurchase.fromJson(i)).toList());
    DateTime dataTime = DateTime(mappa['purchaseTime']);
    List<String> split = dataTime.toString().split(" ");
    Purchase purchase = Purchase(id: mappa['id'], date: split[0], time: split[1], productsInPurchase: list);
    return purchase;
  }

  bool hasError(){
    return message != null;
  }

  @override
  String toString() {
    return "Id: $id, Time: $time, Date: $date";
  }

}