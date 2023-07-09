import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/objects/ProductInPurchase.dart';
import 'package:project_ecommerce/model/objects/Purchase.dart';
import 'package:project_ecommerce/model/support/Communicator.dart';

import '../../../Model.dart';
import '../../../support/AppBarPurchaseCommunicator.dart';
import '../../../support/Constants.dart';
import '../dialog/MessageDialog.dart';
import 'AppBarPurchase.dart';


class AppBarCart extends StatelessWidget {
  const AppBarCart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff5065a4),
        useMaterial3: true,
      ),
      home: const AppBarExample(),
    );
  }

}

class AppBarExample extends StatefulWidget {
  const AppBarExample({super.key});

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  double? scrolledUnderElevation;
  List<ProductInPurchase> _items = Communicator.sharedInstance.listaPipInCart;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: GridView.builder(
        itemCount: _items.length,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          mainAxisExtent: 120,
        ),

        itemBuilder: (BuildContext context, int index) {

          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: evenItemColor, // provare l'altro commentato eventualmente
              ),
              child: Center(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        String esito = await Communicator.sharedInstance.removeProdFromCart(_items[index]);
                        showDialog(
                          context: context,
                          builder: (context) => MessageDialog(
                            titleText: esito == "OK"? "Prodotto rimosso con successo" : elaboraRisposta(esito), bodyText: '',
                          ),
                        );

                        setState(() {
                          //_items = Communicator.sharedInstance.listaPipInCart;
                        });
                      },
                      icon: const Icon(Icons.remove_circle),
                      tooltip: 'Rimuovi prodotto',
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _items[index].product.name,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${_items[index].price}\$',
                            textAlign: TextAlign.center,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Quantità: ${_items[index].quantity}',
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  tooltip: 'Aumenta quantità',
                                  onPressed: () async {
                                    int qntNow = _items[index].quantity;
                                    if(qntNow+1 <= _items[index].product.quantity){
                                      String esito = await Communicator.sharedInstance.plusProductOfCart(_items[index]);
                                      if(esito != "OK") {
                                        showDialog(
                                          context: context,
                                          builder: (context) => MessageDialog(
                                            titleText: elaboraRisposta(esito), bodyText: '',
                                          ),
                                        );
                                      }
                                    }
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.add),
                                ),

                                IconButton(
                                  tooltip: 'Diminuisci quantità',
                                  onPressed: () async {
                                    int qntNow = _items[index].quantity;
                                    String esito = "";
                                    if(qntNow-1 >= 1){
                                      esito = await Communicator.sharedInstance.minusProductOfCart(_items[index]);
                                    } else {
                                      esito = await Communicator.sharedInstance.removeProdFromCart(_items[index]);
                                    }
                                    if(esito != "OK"){
                                      showDialog(
                                        context: context,
                                        builder: (context) => MessageDialog(
                                          titleText: elaboraRisposta(esito), bodyText: '',
                                        ),
                                      );
                                    }
                                    setState(() {
                                      //_items = Communicator.sharedInstance.listaPipInCart;
                                    });
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              )
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            alignment: MainAxisAlignment.center,
            overflowSpacing: 5.0,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () async {
                  if(!Model.sharedInstance.isLogged()){
                    showDialog(
                      context: context,
                      builder: (context) => const MessageDialog(
                        titleText: "Impossibile procedere con l'acquisto. Effettua prima il log-in",
                      ),
                    );
                  } else if(Communicator.sharedInstance.listaPipInCart.isNotEmpty){
                    String esito = await Communicator.sharedInstance.createPurchase();
                    showDialog(
                      context: context,
                      builder: (context) => MessageDialog(
                        titleText: "Resoconto acquisto",
                        bodyText: verifyPurchaseResponse(esito),
                      ),
                    );
                    if(!esito.contains("_")){
                      Communicator.sharedInstance.clearCart();
                      setState(() {
                        _items = [];
                      });
                    }

                  }
                },
                icon: const Icon(Icons.add_card_outlined),
                label: const Text('Conferma acquisto'),
              ),
              const SizedBox(width: 5),
              ElevatedButton.icon(
                onPressed: () async {
                  String esito = await Communicator.sharedInstance.removeAllProdFromCart();
                  setState(() {
                    //_items = Communicator.sharedInstance.listaPipInCart;
                  });
                  showDialog(
                    context: context,
                    builder: (context) => MessageDialog(
                      titleText: esito == "OK"? "Carrello svuotato con successo" : elaboraRisposta(esito), bodyText: '',
                    ),
                  );
                },
                icon: const Icon(Icons.clear),
                label: const Text( 'Svuota carrello' ),
              ),
              ElevatedButton.icon(
                onPressed: Model.sharedInstance.isLogged() ? ()  async {
                  List<Purchase>? acquisti = await AppBarPurchaseCommunicator.sharedInstance.getPurchase(0); /// Avrei potuto usare anche un metodo che restituisce un booleano
                  if(context.mounted){
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return Scaffold(
                            appBar: AppBar(
                              title: const Text('Storico'),
                            ),
                            body: acquisti!.isEmpty ? const Center(
                              child: Text(
                                'Nessun acquisto effettuato',
                                style: TextStyle(fontSize: 24),
                              ),
                            ) : const AppBarPurchase()
                        );
                      },
                    ));
                  }

                } : null,
                icon: const Icon(Icons.storage),
                label: const Text( 'Visualizza acquisti' ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Il seguente metodo si occupa di ricevere le costanti dal server o dal client ed elaborare la risposta da visualizzare
  String elaboraRisposta(String esito) {
    String risposta = "";
    if(esito == "CONNECTION_ERROR") {
      risposta = "Errore di rete! Riprova piu' tardi";
    } else if (esito == Constants.RESPONSE_ERROR_USERNAME_NOT_FOUND) {
      risposta = "E' pregato di rieseguire il log-in. Se il problema persiste contatti l'assistenza";
    } else if (esito == Constants.RESPONSE_ERROR_INNER_ERROR_TRY_LATER) {
      risposta = "Al momento i nostri server sono pieni. Riprova piu' tardi";
    } else if (esito == Constants.RESPONSE_ERROR_PRODUCT_IN_PURCHASE_NOT_EXIST_IN_CART) {
      risposta = "Il prodotto nel carrello che desideri modificare risulta essere mancante";
    } else if (esito == Constants.RESPONSE_ERROR_INTERNAL_ERROR_TRY_LATER) {
      risposta = "Formulazione scorretta della richiesta. Contatta l'amministratore per ulteriori chiarimenti";
    } else if (esito == "ACCESS_DENIED") {
      risposta = "Non hai i privilegi per accedere a questa funzionalità";
    }
    return risposta;
  }

  String verifyPurchaseResponse(String esito){
    String risposta = elaboraRisposta(esito);
    if(risposta == "") {
      if (esito.split('_')[0] == Constants.RESPONSE_ERROR_PRODUCT) {
        List<String> parts = esito.split('_');
        String nameOrIdProd = parts[1];
        String info = parts[2];
        switch (info) {
          case "PRICE":
            risposta =
            "Ci dispiace ma sembra che il prezzo per il prodotto $nameOrIdProd risulta essere cambiato. Riprova l'acquisto";
            break;
          case "QUANTITY":
            risposta =
            "Ci dispiace ma sembra che il prodotto $nameOrIdProd per la quantità specificata risulta non essere disponibile. Riprova l'acquisto";
            break;
          case "NOT":
            risposta =
            "Ci dispiace ma sembra che il prodotto con id $nameOrIdProd risulta essere rimosso dal magazzino";
            break;
          case "IN":
            risposta =
            "Ci dispiace ma sembra che ci siano problemi di inconsistenza nel carrello. Assicurati di essere l'unico proprietario dell'account. Se il problema persiste contatta l'assistenza";
            break;
          case "INCONSISTENCY":
            risposta =
            "Ci dispiace ma sembra che ci siano problemi di inconsistenza nel carrello. Assicurati di essere l'unico proprietario dell'account. Se il problema persiste contatta l'assistenza";
            break;
        }
      }
    }
    /// Se nessuno dei casi precedenti è contemplato ipotizziamo che è l'acquisto dunque procedo col farlo visualizzare (potrebbe essere un errore sconosciuto)
    return risposta == ""? esito : risposta;
  }

}
