import 'package:flutter/material.dart';


class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CircularIconButton({super.key, required this.icon, this.onPressed});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: RawMaterialButton( //pulsante di base che mette a disposizione flutter
        fillColor: Theme.of(context).primaryColor,
        onPressed: onPressed,
        shape: const CircleBorder(),
        elevation: 2.0,
        padding: const EdgeInsets.all(15),
        child: Icon(
          icon,
        ),
      ),
    );
  }


}