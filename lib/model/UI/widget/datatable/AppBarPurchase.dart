import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/objects/ProductInPurchase.dart';
import 'package:project_ecommerce/model/support/AppBarPurchaseCommunicator.dart';

import '../../../objects/Purchase.dart';
import '../dialog/MessageDialog.dart';

class AppBarPurchase extends StatelessWidget {
  const AppBarPurchase({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff5065a4),
        useMaterial3: true,
      ),
      home: const AppBarExample2(),
    );
  }

}

class AppBarExample2 extends StatefulWidget {
  const AppBarExample2({super.key});

  @override
  State<AppBarExample2> createState() => _AppBarPurchaseState();
}

class _AppBarPurchaseState extends State<AppBarExample2> {
  double? scrolledUnderElevation;
  final List<Purchase> _items = AppBarPurchaseCommunicator.sharedInstance.purchases; /// Di default è la pagina 0-esima

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
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => MessageDialog(
                                  titleText: 'Riepilogo prodotti',
                                  bodyText: visualizzaProdotti(_items[index].productsInPurchase!),
                                ),
                              );
                            },
                            icon: const Icon(Icons.info),
                            tooltip: 'Info prodotti',
                          ),
                          Text(
                            'Id: ${_items[index].id}',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Data: ${_items[index].date}',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Ora: ${_items[index].time}',
                            textAlign: TextAlign.center,
                          ),

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
                onPressed: () {

                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Ordina per data'),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }

  String visualizzaProdotti(List<ProductInPurchase> products) {
    String response = '';
    for(ProductInPurchase pip in products){
      response += '$pip\n';
    }
    return response;
  }

}
