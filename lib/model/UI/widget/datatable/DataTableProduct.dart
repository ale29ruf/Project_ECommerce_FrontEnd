
import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/support/Communicator.dart';
import 'package:project_ecommerce/model/support/ProductSortBy.dart';
import 'package:project_ecommerce/model/support/SearchBarCommunicator.dart';

import '../../../Model.dart';
import '../../../objects/Product.dart';
import '../dialog/MessageDialog.dart';

class DataTableProduct extends StatefulWidget {

  const DataTableProduct({super.key});

  @override
  State<DataTableProduct> createState() {
    return _DataTableProductState();
  }

}

class _DataTableProductState extends State<DataTableProduct> {
  /// Posizionare in questa classe tutto cio' che non deve cambiare ad ogni rebuid del widget

  final List<Product> _product = []; /// Lista dei prodotti da visualizzare
  final List<bool> _selectedRow = []; /// Lista dei booleani associati ai prodotti (necessari per la selezione all'interno della tabella)

  final int MAX_PROD_PER_PAGE = 10;
  int numPag = 0;
  ProductSortBy selectedOrder = ProductSortBy.id;

  _DataTableProductState();

  @override
  void initState() {
    super.initState();
    Communicator.sharedInstance.setDataTableRefresh(refresh);
    Communicator.sharedInstance.setCaricaProdotti(_caricaProdotti);
    SearchBarCommunicator.sharedInstance.setListOfProduct(_product);
    SearchBarCommunicator.sharedInstance.setListOfProductBool(_selectedRow);
    SearchBarCommunicator.sharedInstance.setDataTableRefresh(refresh);
    SearchBarCommunicator.sharedInstance.setShowBanner(showBanner);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: _product.isNotEmpty ? const Text('Prodotti disponibili') : const Text('Nessun prodotto disponibile'),
            leading: PopupMenuButton<ProductSortBy>(
              tooltip: 'Seleziona il tipo di ordinamento',
              onSelected: (ProductSortBy scelta) {
                selectedOrder = scelta;
                _caricaProdotti();
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<ProductSortBy>>[
                const PopupMenuItem<ProductSortBy>(
                  value: ProductSortBy.id,
                  child: Text('Ordina per id'),
                ),
                const PopupMenuItem<ProductSortBy>(
                  value: ProductSortBy.name,
                  child: Text('Ordina per nome'),
                ),
                const PopupMenuItem<ProductSortBy>(
                  value: ProductSortBy.price,
                  child: Text('Ordina per prezzo'),
                ),
              ],
            ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: CostumSearchDelegate()
                        );
                      },
                      icon: const Icon(Icons.search)
                  ),
                  IconButton(
                    onPressed: () {
                      if(numPag >= 1) numPag--;
                      _caricaProdotti();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ) ,
                  Text(numPag.toString()),
                  IconButton(
                    onPressed: () {
                      numPag++;
                      _caricaProdotti();
                    },
                    icon: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
            ),
          ],

        ),
        body: _product.isNotEmpty ? DataTableExample(product : _product, selectedRow: _selectedRow) : Center(
              child: IconButton(
                onPressed: () {
                  _caricaProdotti();
                },
                icon: const Icon(Icons.add_box),
          ) ,
        ),
      ),
    );
  }

  Future<List<Product>?> _caricaProdotti() async {
    List<Product>? product;
    try{
      product = await Model.sharedInstance.searchProductPaged(numPag, MAX_PROD_PER_PAGE, orderBy: selectedOrder);
      _selectedRow.clear();
      for (int i = 0; i < product!.length; i++) {
        _selectedRow.add(false);
      }
    } catch(e) {
      return null;
    }
    setState(() {
      _product.clear();
      for(Product p in product!) {
        _product.add(p);
      }
    });
    return product;
  }

  void refresh(){
    setState(() {});
  }

  void showBanner(String testo){
    showDialog(
      context: context,
      builder: (context) => MessageDialog(
        titleText: "Messaggio",
        bodyText: testo,
      ),
    );
  }

}

class CostumSearchDelegate extends SearchDelegate {

  @override
  List<Widget>? buildActions(BuildContext context) { /// rimuove l'input della search bar, se e' vuoto allora rimuove la search bar
    return [
      IconButton(
          onPressed: () {
          if(query.isEmpty){
            close(context, null);
          } else {
            query = '';
          }
        },
          icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          SearchBarCommunicator.sharedInstance.showResultOn(query);
          close(context, null);
        },
        icon: const Icon(Icons.search)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }

}

class DataTableExample extends StatelessWidget { ///ATTENZIONE: essendo un widget stateless viene ridisegnato ogni volta dall'inizio
  final List<Product> product;
  final List<bool> selectedRow;

  const DataTableExample({super.key, required this.product, required this.selectedRow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
                columnSpacing: 150.0,
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

              )
          ),


    );


  }

  List<DataRow> _caricaDatiTabella(){
    List<DataRow> rows = [];
    for (int i = 0; i < product.length; i++) {
      DataRow row = DataRow(
        cells: <DataCell>[ //Text(product[i].id.toString())
          DataCell(ConstrainedBox(constraints: const BoxConstraints(maxWidth: 250), //SET max width
              child: Text(product[i].id.toString(),
    overflow: TextOverflow.ellipsis),
            
          )),
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


