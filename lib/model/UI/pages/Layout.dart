import 'package:flutter/material.dart';

import 'LogIn.dart';
import 'SignUp.dart';
import 'Welcome.dart';

class Layout extends StatelessWidget {
  final String title;


  const Layout({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold( //contenitore di un pannello
        appBar: AppBar( //barra dell'applicazione
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Home"),
              Tab(text: "Registrati"),
              Tab(text: "Accedi"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Welcome(),
            SignUp(),
            LogIn(),
          ],
        ),
      ),
    );
  }
}

