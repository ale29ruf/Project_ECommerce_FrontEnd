
import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/support/Communicator.dart';

import '../../../Model.dart';
import '../../../objects/Product.dart';

class DataTableProduct extends StatefulWidget {

  DataTableProduct({super.key});

  @override
  State<DataTableProduct> createState() {
    return _DataTableProductState();
  }

}

class _DataTableProductState extends State<DataTableProduct> {
  /// Posizionare in questa classe tutto cio' che non deve cambiare ad ogni rebuid del widget
  List<Product>? _product;
  final int MAX_PROD_PER_PAGE = 10;
  final List<bool> _selectedRow = [];

  _DataTableProductState();

  @override
  void initState() {
    super.initState();
    Communicator.sharedInstance.setDataTableRefresh(refresh);
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild DataTableProduct");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: _product != null? const Text('Prodotti disponibili') : const Text('Nessun prodotto disponibile')),
        body: _product != null? DataTableExample(product : _product!, selectedRow: _selectedRow,) :
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
      for (int i = 0; i < product!.length; i++) {
        _selectedRow.add(false);
      }
    } catch(e) {
      return null;
    }
    setState(() {
      _product = product;
    });
    return product;
  }

  void refresh(){
    print("Nel metodo refresh");
    setState(() {

    });
  }

}

class DataTableExample extends StatelessWidget { ///ATTENZIONE: essendo un widget stateless viene ridisegnato ogni volta dall'inizio
  final List<Product> product;
  final List<bool> selectedRow;

  const DataTableExample({super.key, required this.product, required this.selectedRow});

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
    for (int i = 0; i < product.length; i++) {
      DataRow row = DataRow(
        cells: <DataCell>[ //Text(product![i].id.toString())
          DataCell(Text(product[i].id.toString())),
          DataCell(Text(product[i].name)),
          DataCell(Text(product[i].barCode)),
          DataCell(Text(product[i].price.toString())),
          DataCell(Text(product[i].quantity.toString())),
          DataCell(Text(product[i].description)),
        ],
        selected: selectedRow[i],
        onSelectChanged: (value) {
          if(!selectedRow[i]) {
            selectedRow[i] = true;
            Communicator.sharedInstance.addProd(product[i]);
          } else {
            selectedRow[i] = false;
            Communicator.sharedInstance.removeProd(product[i]);
          }
        }
      );
      rows.add(row);
    }
    return rows;
  }

}


