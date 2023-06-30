
import 'package:flutter/material.dart';

import '../../../objects/Product.dart';

class DataTableProduct extends StatefulWidget {
  final List<Product>? product;

  const DataTableProduct({super.key, this.product});

  @override
  State<DataTableProduct> createState() => _DataTableProduct(this.product);
}

class _DataTableProduct extends State<DataTableProduct> {
  List<Product>? product;

  _DataTableProduct(this.product);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: product == null? const Text('Prodotti disponibili') : const Text('Nessun prodotto disponibile')),
        body: product != null? DataTableExample(product : product) : const SizedBox.shrink(),
      ),
    );
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
              'Codice acquisto',
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
      ],
      rows: _caricaDatiTabella() ,
    );
  }

  List<DataRow> _caricaDatiTabella(){
    List<DataRow> rows = [];
    for (int i = 0; i < product!.length; i++) {
      DataRow row = DataRow(
        cells: <DataCell>[
          DataCell(Text(product![i].id as String)),
          DataCell(Text(product![i].name)),
          DataCell(Text(product![i].barCode)),
          DataCell(Text(product![i].price as String)),
          DataCell(Text(product![i].quantity as String)),
          DataCell(Text(product![i].description)),
        ],
      );
      rows.add(row);
    }
    return rows;
  }
}


