import 'package:project_ecommerce/model/objects/Product.dart';

class ProductInPurchase {
  int id;
  int quantity;
  double price;
  Product product;

  ProductInPurchase({required this.id, required this.quantity, required this.price, required this.product});

  factory ProductInPurchase.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> prod = json['product'];
    return ProductInPurchase(
        id: json['id'],
        quantity: json['quantity'],
        price: json['price'],
        product: Product(
          id: prod['id'],
          name: prod['name'],
          barCode: prod['barCode'],
          description: prod['description'],
          price: prod['price'],
          quantity: prod['quantity'],
        )
    );
  }

  Map<String, dynamic> toJson() => { //Converte il Product in un oggetto json. E' necessario solo l'id
    'id': id,
    'quantity' : quantity,
    'price' : price,
    'product' : product.id /// Al server serve solo l'id del prodotto
  };

  @override
  String toString() {
    return "\n\n{ Id: $id, \nQuantità: $quantity, \nPrezzo: $price, \nProdotto: $product }";
  }

}