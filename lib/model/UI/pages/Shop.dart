import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/UI/widget/datatable/DataTableProduct.dart';


class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

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
      body: DataTableProduct(  )
      ,);
  }

}
