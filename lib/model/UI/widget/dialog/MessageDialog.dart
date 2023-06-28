import 'package:flutter/material.dart';
import '../../aspect/TextStyles.dart';
import 'RoundedDialog.dart';


class MessageDialog extends StatelessWidget {
  final String titleText;
  final String bodyText;


  const MessageDialog({super.key, required this.titleText, required this.bodyText});

  @override
  Widget build(BuildContext context) {
    return RoundedDialog(
      title: Text(
        titleText,
        style: TitleStyle(),
        textAlign: TextAlign.center,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
        child: Text(
          bodyText,
          style: ParagraphStyle(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


}