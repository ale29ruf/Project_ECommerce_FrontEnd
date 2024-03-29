import 'package:flutter/material.dart';


class BigBoldTitleStyle extends TextStyle {

  @override
  FontWeight get fontWeight => FontWeight.bold;
  @override
  double get fontSize => 30;

}

class BigTitleStyle extends TextStyle {

  @override
  FontWeight get fontWeight => FontWeight.w300;

}

class TitleStyle extends TextStyle {

  @override
  FontWeight get fontWeight => FontWeight.bold;

}

class ParagraphStyle extends TextStyle { //personalizzazione degli stili

  @override
  FontWeight get fontWeight => FontWeight.w800;
  @override
  Color get color => Colors.green;

}
