import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/objects/Product.dart';
import 'package:project_ecommerce/model/support/Communicator.dart';

import '../dialog/MessageDialog.dart';


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
  List<Product> _items = Communicator.sharedInstance.listaProdInCart;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
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
        ),
        itemBuilder: (BuildContext context, int index) {

          return Container(
            alignment: Alignment.center,
            // tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: evenItemColor, // provare l'altro commentato eventualmente
            ),
            child: Center(
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const MessageDialog(
                          titleText: "Prodotto rimosso con successo", bodyText: '',
                        ),
                      );
                      Communicator.sharedInstance.removeProdFromCart(_items[index]);
                      setState(() {
                        _items = Communicator.sharedInstance.listaProdInCart;
                      });
                      },
                    icon: const Icon(Icons.remove_circle),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _items[index].name,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${_items[index].price}\$',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
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
                  //setState(() {

                  //});
                },
                icon: const Icon(Icons.add_card_outlined),
                label: const Text('Conferma acquisto'),
              ),
              const SizedBox(width: 5),
              ElevatedButton.icon(
                onPressed: () {

                },
                icon: const Icon(Icons.clear),
                label: const Text( 'Svuota carrello' ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
