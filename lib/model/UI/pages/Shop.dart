import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/UI/widget/datatable/DataTableProduct.dart';
import 'package:project_ecommerce/model/support/Communicator.dart';
import 'package:project_ecommerce/model/support/Constants.dart';

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
            onPressed: () async {

              ScaffoldMessenger.of(context).showSnackBar(
                  Communicator.sharedInstance.listaProdSelected.isEmpty?
                  const SnackBar(content: Text('Nessun prodotto selezionato')) :
                  Communicator.sharedInstance.listaProdSelected.length > 1?
                  const SnackBar(content: Text('Prodotti aggiunti')) :
                  const SnackBar(content: Text('Prodotto aggiunto')) );
              String esito = await Communicator.sharedInstance.putProdInCart();
              showDialog(
                  context: context,
                  builder: (context) => MessageDialog(
                    titleText: esito == "OK"? "Operazione andata a buon fine ": elaboraRisposta(esito), bodyText: '',
                  )
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.card_travel),
            tooltip: 'Vai al carrello',
            onPressed: () async {
              String esito = await Communicator.sharedInstance.visualizeCart();
              if(context.mounted){
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                        appBar: AppBar(
                          title: const Text('Carrello'),
                        ),
                        body: Communicator.sharedInstance.listaPipInCart.isEmpty ? const Center(
                          child: Text(
                            'Carrello vuoto',
                            style: TextStyle(fontSize: 24),
                          ),
                        ) :
                        esito == "OK"? const AppBarCart() :
                        Center(
                          child: Text(
                            elaboraRisposta(esito),
                            style: const TextStyle(fontSize: 24),
                          ),
                        )
                    );
                  },
                ));
              }

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

  String elaboraRisposta(String esito) {
    String risposta = "";
    if(esito == "CONNECTION_ERROR") {
      risposta = "Errore di rete! Riprova piu' tardi";
    } else if (esito == Constants.RESPONSE_ERROR_USERNAME_NOT_FOUND) {
      risposta = "E' pregato di rieseguire il log-in. Se il problema persiste contatti l'assistenza";
    } else if (esito == Constants.RESPONSE_ERROR_INNER_ERROR_TRY_LATER) {
      risposta = "Al momento i nostri server sono pieni. Riprova piu' tardi";
    } else if (esito == Constants.RESPONSE_ERROR_PRODUCT_NOT_EXIST) {
      risposta = "Il prodotto selezionato risulta essere non disponibile";
    }
    return risposta;
  }

}
