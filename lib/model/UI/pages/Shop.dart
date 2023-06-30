import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/UI/widget/datatable/DataTableProduct.dart';
import 'package:project_ecommerce/model/objects/Product.dart';

import '../../Model.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final int MAX_PROD_PER_PAGE = 10;
  List<Product>? _product;
  final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 5));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prodotti'),
        leading: IconButton(
          icon: const Icon(Icons.account_tree_outlined),
          onPressed: () {
            _caricaProdotti();
          },
          tooltip: 'Carica prodotti',
        ),
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
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 400,
            child: DataTableProduct(
                product: _product
            ),
          ),

      ],
    ),);
  }

  Future<List<Product>?> _caricaProdotti() async {
    List<Product>? product;
    try{
      product = await Model.sharedInstance.searchProductPaged(0, MAX_PROD_PER_PAGE);
    } catch(e) {
      return null;
    }
    setState(() {
      _product = product;
    });
    return product;
  }
}
