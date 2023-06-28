import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InputField extends StatelessWidget {
  final String? labelText;
  final bool? multiline;
  final bool? enabled;
  final bool isPassword;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<String?>? onSubmit;
  final VoidCallback? onTap;
  final int? maxLength;
  final TextAlign textAlign;
  final TextEditingController? controller;
  final TextInputType? keyboardType;


  const InputField({super.key, this.labelText, this.controller, this.onChanged, this.onSubmit, this.onTap, this.keyboardType, this.multiline, this.maxLength, this.isPassword = false, this.enabled = true, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5), //imposta uno spazio di riempimento uniforme di 5 unità su tutti i lati del widget
      child: TextField(
        enabled: enabled,
        maxLength: maxLength,
        obscureText: isPassword,
        textAlign: textAlign,
        maxLines: multiline != null && multiline == true ? null : 1,
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.number ? <TextInputFormatter>[ //come vogliamo formattare il testo all'interno del TextFiled
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ] : null,
        onChanged: onChanged,
        onSubmitted: onSubmit,
        onTap: onTap, //potrebbe essere un metodo che conta il numero di click
        controller: controller, //il controller permette di operare sul TextField
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(
          height: 1.0,
          color: Theme.of(context).primaryColor,
        ),
        decoration: InputDecoration( //I decorator permettono di castomizzare l'aspetto dei widget. In particolare l'InputDecorator server per gli InputField
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          fillColor: Theme.of(context).primaryColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }


}