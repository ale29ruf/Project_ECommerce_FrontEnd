import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/UI/widget/datatable/DataTableProduct.dart';
import 'package:project_ecommerce/model/support/Communicator.dart';

import '../../Model.dart';
import '../widget/datatable/AppBarCart.dart';
import '../widget/dialog/MessageDialog.dart';


class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  @override
  void initState() {
    super.initState();
  }

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
                        'Carrello vuoto',
                        style: TextStyle(fontSize: 24),
                      ),
                    ) : const AppBarCart()
                  );
                },
              ));
            },
          ),
          ActionChip(
            avatar: Icon(Model.sharedInstance.isLogged() ? Icons.check : Icons.not_interested),
            label: const Text('Logged'),
            autofocus: true,

            elevation: 20.0,
            backgroundColor: Colors.blue,
            onPressed: () async {
              if(!Model.sharedInstance.isLogged()){
                showDialog(
                  context: context,
                  builder: (context) => const MessageDialog(
                    titleText: "Non hai effettuato ancora il log-in",
                  ),
                );
              } else {
                await Model.sharedInstance.logOut();
                  showDialog(
                    context: context,
                    builder: (context) => MessageDialog(
                      titleText: Model.sharedInstance.isLogged() ? "Log-out fallito" : "Log-out eseguito con successo",
                    ),
                  );
                  setState(() {  });
                }
            },
          ),
        ],
      ),
      body: DataTableProduct(),
      );
  }


}
