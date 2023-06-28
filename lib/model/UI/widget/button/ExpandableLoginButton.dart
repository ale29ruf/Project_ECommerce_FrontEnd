import 'package:flutter/material.dart';

import '../InputField.dart';
import 'StadiumButton.dart';


class ExpandableLogInButton extends StatefulWidget {
  final String textOuterButton;
  final Function onSubmit;


  const ExpandableLogInButton({super.key, required this.textOuterButton, required this.onSubmit});

  @override
  _ExpandableLogInButton createState() => _ExpandableLogInButton(this.textOuterButton, this.onSubmit);

}


class _ExpandableLogInButton extends State<ExpandableLogInButton> with TickerProviderStateMixin { //TickerProviderStateMixin e' una classe che serve all'oggetto Animation per fare le animazioni
  late final String textOuterButton; //late -> la variabile sara' istanziata dopo
  late final Function onSubmit;

  late AnimationController _topAnimationController;
  late AnimationController _bottomAnimationController;
  late Animation<double> _topAnimation;
  late Animation<double> _bottomAnimation;
  final TextEditingController _inputFieldEmailController = TextEditingController();
  final TextEditingController _inputFieldPasswordController = TextEditingController();


  _ExpandableLogInButton(this.textOuterButton, this.onSubmit);

  @override
  void initState() {
    super.initState(); //primo metodo invocato nel ciclo di vita dell'animazione (dopo il costruttore)
    _topAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _topAnimationController.value = 1;
    _topAnimationController.addListener(() {
      setState(() {});
    });
    _bottomAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _bottomAnimationController.value = 0;
    _bottomAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _topAnimation = CurvedAnimation(parent: _topAnimationController, curve: Curves.easeInOut,);
    _bottomAnimation = CurvedAnimation(parent: _bottomAnimationController, curve: Curves.easeInOut,);
    return Column(
      children: [
        SizeTransition( //effettua la transizione
          axisAlignment: 1.0,
          sizeFactor: _topAnimation,
          child: Center(
            child: Column(
              children: [
                StadiumButton(
                  icon: Icons.people_rounded,
                  title: textOuterButton,
                  onPressed: () {
                    if (_bottomAnimationController.status == AnimationStatus.dismissed) {
                      _bottomAnimationController.forward();
                    }
                    if (_topAnimationController.status == AnimationStatus.completed) {
                      _topAnimationController.reverse();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: _bottomAnimation,
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 300,
                  child: InputField(
                    labelText: "username",
                    controller: _inputFieldEmailController,
                  ),
                ),
                Container(
                  width: 300,
                  child: InputField(
                    labelText: "password",
                    controller: _inputFieldPasswordController,
                    isPassword: true,
                    onSubmit: (_) {
                      onSubmit(_inputFieldEmailController.text, _inputFieldPasswordController.text);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: StadiumButton(
                    icon: Icons.login,
                    title: "Invia",
                    padding: 0,
                    onPressed: () {
                      onSubmit(_inputFieldEmailController.text, _inputFieldPasswordController.text);
                      _inputFieldPasswordController.text = "";
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


}
