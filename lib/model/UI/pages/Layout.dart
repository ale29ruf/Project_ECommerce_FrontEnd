import 'package:flutter/material.dart';

import 'LogIn.dart';
import 'SignUp.dart';

class Layout extends StatelessWidget {
  final String title;


  const Layout({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              Tab(text: "Sign Up"),
              Tab(text: "Log In"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SignUp(),
            LogIn(),
          ],
        ),
      ),
    );
  }
}

