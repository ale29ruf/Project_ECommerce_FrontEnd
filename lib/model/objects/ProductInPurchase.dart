class ProductInPurchase {
  int id;
  int quantity;
  double price;
  int product;

  ProductInPurchase({required this.id, required this.quantity, required this.price, required this.product});

  factory ProductInPurchase.fromJson(Map<String, dynamic> json) {
    return ProductInPurchase(
        id: json['id'],
        quantity: json['quantity'],
        price: json['price'],
        product: json['product'],
    );
  }

  Map<String, dynamic> toJson() => { //Converte il Product in un oggetto json. E' necessario solo l'id
    'id': id,
    'quantity' : quantity,
    'price' : price,
    'product' : product
  };

  @override
  String toString() {
    return "$id $quantity $price $product";
  }

}