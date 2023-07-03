import 'package:flutter/material.dart';
import 'package:project_ecommerce/model/UI/pages/Layout.dart';
import 'package:project_ecommerce/model/support/Constants.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.APP_NAME,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                }
                return Colors.lightBlueAccent;
              },
            ),
          ),
        ),
      ),
      home: const Layout(title: Constants.APP_NAME), //home e' la prima pagina che viene segnata
    );
  }
}
