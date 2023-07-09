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
      restorationScopeId: 'app',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff5065a4),
        useMaterial3: true,
      ),
      home: const AppBarExample2(restorationId: 'main'),
    );
  }

}

class AppBarExample2 extends StatefulWidget {
  const AppBarExample2({super.key, this.restorationId});
  final String? restorationId;

  @override
  State<AppBarExample2> createState() => _AppBarPurchaseState();
}

class _AppBarPurchaseState extends State<AppBarExample2> with RestorationMixin{
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
                            'Ora: ${_items[index].getTime()}',
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
                  setState(() {
                    _restorableDatePickerRouteFuture.present();
                  });
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

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
  RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        // TODO completare
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

}
