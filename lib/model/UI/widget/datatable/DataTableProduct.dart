
import 'package:flutter/material.dart';

import '../../../Model.dart';
import '../../../objects/Product.dart';

class DataTableProduct extends StatefulWidget {

  DataTableProduct({super.key});

  @override
  State<DataTableProduct> createState() {
    return _DataTableProduct();
  }


}

class _DataTableProduct extends State<DataTableProduct> {
  List<Product>? _product;
  final int MAX_PROD_PER_PAGE = 10;

  _DataTableProduct();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: _product != null? const Text('Prodotti disponibili') : const Text('Nessun prodotto disponibile')),
        body: _product != null? DataTableExample(product : _product) :
        Center(
          child: IconButton(
            onPressed: () {
              _caricaProdotti();
            },
            icon: const Icon(Icons.pageview_rounded),
          ),
        ),
      ),
    );
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

class DataTableExample extends StatelessWidget {
  final List<Product>? product;

  const DataTableExample({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Id',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Nome',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Codice acquisto',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Prezzo',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Quantità',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Descrizione',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: _caricaDatiTabella() ,
    );
  }

  List<DataRow> _caricaDatiTabella(){
    List<DataRow> rows = [];
    for (int i = 0; i < product!.length; i++) {
      DataRow row = DataRow(
        cells: <DataCell>[
          DataCell(Text(product![i].id.toString())),
          DataCell(Text(product![i].name)),
          DataCell(Text(product![i].barCode)),
          DataCell(Text(product![i].price.toString())),
          DataCell(Text(product![i].quantity.toString())),
          DataCell(Text(product![i].description)),
        ],
      );
      rows.add(row);
    }
    return rows;
  }
}


