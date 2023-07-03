import 'package:flutter/material.dart';
import '../../aspect/TextStyles.dart';
import 'RoundedDialog.dart';


class MessageDialog extends StatelessWidget {
  final String titleText;
  final String? bodyText;


  const MessageDialog({super.key, required this.titleText, this.bodyText});

  @override
  Widget build(BuildContext context) {
    return RoundedDialog(
      title: Text(
        titleText,
        style: TitleStyle(),
        textAlign: TextAlign.center,
        textScaleFactor: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
        child: bodyText != null ? Text(
          bodyText!,
          style: ParagraphStyle(),
          textAlign: TextAlign.center,
        ) : const SizedBox.shrink(),
      ),
    );
  }


}