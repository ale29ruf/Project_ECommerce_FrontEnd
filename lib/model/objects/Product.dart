
class Product {
  int id;
  String name;
  String barCode;
  String description;
  double price;
  int quantity;
  int? idPip;

  Product({required this.id, required this.name, required this.barCode, required this.description, required this.price, required this.quantity, this.idPip}); //il costruttore puo' essere usato a prescindere da quale parametro viene passato

  factory Product.fromJson(Map<String, dynamic> json) { //Costruisce il Product a partire da una mappa. Il tipo del valore della mappa "dynamic" puo' variare.
    return Product(
      id: json['id'],
      name: json['name'],
      barCode: json['barCode'],
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => { //Converte il Product in un oggetto json. E' necessario solo l'id
    'id': id,
  };

  @override
  String toString() {
    return "{ Id: $id, Nome: $name}";
  }


}