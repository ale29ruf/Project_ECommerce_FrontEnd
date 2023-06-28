import 'package:flutter/material.dart';


class RoundedDialog extends StatelessWidget {
  final Widget title;
  final Widget body;


  const RoundedDialog({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      children: [
        body,
      ],
    );
  }


}