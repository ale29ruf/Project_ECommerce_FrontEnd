import 'package:flutter/material.dart';

import '../../objects/Purchase.dart';
import '../../support/AppBarPurchaseCommunicator.dart';
import '../widget/datatable/AppBarPurchase.dart';

class PurchaseStorage extends StatefulWidget {
  List<Purchase>? result;

  PurchaseStorage({super.key, this.result});

  @override
  State<PurchaseStorage> createState() => _PurchaseStorageState(result!);
}

class _PurchaseStorageState extends State<PurchaseStorage> {
  int numPag = 0;
  List<Purchase> acquisti;

  _PurchaseStorageState(this.acquisti);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Storico'),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      if(numPag >= 1) numPag--;
                      acquisti = (await AppBarPurchaseCommunicator.sharedInstance.getPurchase(numPag))!;
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_back),
                  ) ,
                  Text(numPag.toString()),
                  IconButton(
                    onPressed: () async {
                      numPag++;
                      acquisti = (await AppBarPurchaseCommunicator.sharedInstance.getPurchase(numPag))!;
                      setState(() { });
                    },
                    icon: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
            ),
          ],
        ),
        body: acquisti.isEmpty ? const Center(
          child: Text(
            'Nessun acquisto effettuato',
            style: TextStyle(fontSize: 24),
          ),
        ) : const AppBarPurchase()
    );
  }
}
