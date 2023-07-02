import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/UI/widget/datatable/DataTableProduct.dart';
import 'package:project_ecommerce/model/support/Communicator.dart';

import '../widget/datatable/DataTableProdInCart.dart';


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
                  Communicator.sharedInstance.listaProdSelected.isEmpty?
                  const SnackBar(content: Text('Nessun prodotto selezionato')) :
                  Communicator.sharedInstance.listaProdSelected.length > 1?
                  const SnackBar(content: Text('Prodotti aggiunti')) :
                  const SnackBar(content: Text('Prodotto aggiunto')) );
              Communicator.sharedInstance.putProdInCart(true);
              },
          ),
          IconButton(
            icon: const Icon(Icons.card_travel),
            tooltip: 'Vai al carrello',
            onPressed: () {
              Communicator.sharedInstance.putProdInCart(false);
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Carrello'),
                    ),
                    body: Communicator.sharedInstance.listaProdInCart.isEmpty ? const Center(
                      child: Text(
                        'Questo è il carrello',
                        style: TextStyle(fontSize: 24),
                      ),
                    ) : const DataTableProdInCart( )
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
