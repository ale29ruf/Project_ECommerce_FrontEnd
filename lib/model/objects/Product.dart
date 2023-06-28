class Product {
  int id;
  String name;
  String barCode;
  String description;


  Product({required this.id, required this.name, required this.barCode, required this.description}); //il costruttore puo' essere usato a prescindere da quale parametro viene passato

  factory Product.fromJson(Map<String, dynamic> json) { //Costruisce il Product a partire da una mappa. Il tipo del valore della mappa "dynamic" puo' variare.
    return Product(
      id: json['id'],
      name: json['name'],
      barCode: json['barCode'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => { //Converte il Product in un oggetto json
    'id': id,
    'name': name,
    'barCode': barCode,
    'description': description,
  };

  @override
  String toString() {
    return name;
  }


}