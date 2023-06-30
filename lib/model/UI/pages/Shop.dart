import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/objects/Product.dart';

import '../../Model.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  static Model sharedInstance = Model();
  final int MAX_PROD_PER_PAGE = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prodotti'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Aggiungi al carrello',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Prodotto aggiunto')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.card_travel),
            tooltip: 'Vai al carrello',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Carrello'),
                    ),
                    body: const Center(
                      child: Text(
                        'Questo è il carrello',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Negozio',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Future<List<Product>?> _caricaProdotti() async {
    List<Product>? _product;
    try{
      _product = await Model.sharedInstance.searchProductPaged(0, MAX_PROD_PER_PAGE);
    } catch(e) {
      return null;
    }
    return _product;
  }
}
