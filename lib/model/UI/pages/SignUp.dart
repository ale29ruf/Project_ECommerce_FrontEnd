import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model.dart';
import '../../objects/User.dart';
import '../widget/InputField.dart';
import '../widget/button/CircularIconButton.dart';
import '../widget/dialog/MessageDialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _adding = false;
  User? _justAddedUser;

  final TextEditingController _userNameFiledController = TextEditingController();
  final TextEditingController _codeFiledController = TextEditingController();
  final TextEditingController _firstNameFiledController = TextEditingController();
  final TextEditingController _lastNameFiledController = TextEditingController();
  final TextEditingController _telephoneNumberFiledController = TextEditingController();
  final TextEditingController _emailFiledController = TextEditingController();
  final TextEditingController _addressFiledController = TextEditingController();
  final TextEditingController _passwordFiledController = TextEditingController();
  final TextEditingController _confermaPasswordFiledController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( //il widget consente di dare un comportamento dinamico all'interfaccia grafica. In questo caso fa apparire un elenco che non entra nello schermo del dispositivo in modo scorrevole
        child: Column( //figlio scrollabile
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                'Inserisci le tue informazioni negli appositi',
                style: TextStyle(
                  fontSize: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  InputField(
                    labelText: "Username",
                    controller: _userNameFiledController, //ogni campo di testo ha il proprio controller
                  ),
                  InputField(
                    labelText: "Nome",
                    controller: _firstNameFiledController, //ogni campo di testo ha il proprio controller
                  ),
                  InputField(
                    labelText: "Cognome",
                    controller: _lastNameFiledController,
                  ),
                  InputField(
                    labelText: "Codice fiscale",
                    controller: _codeFiledController,
                  ),
                  InputField(
                    labelText: "Numero telefonico",
                    controller: _telephoneNumberFiledController,
                  ),
                  InputField(
                    labelText: "E-mail",
                    controller: _emailFiledController,
                  ),
                  InputField(
                    labelText: "Indirizzo",
                    controller: _addressFiledController,
                  ),
                  InputField(
                    labelText: "Password",
                    isPassword: true,
                    controller: _passwordFiledController,
                  ),
                  InputField(
                    labelText: "Conferma password",
                    isPassword: true,
                    controller: _confermaPasswordFiledController,
                  ),
                  //Manca il campo password
                  CircularIconButton(
                    icon: Icons.person_rounded,
                    onPressed: () {
                      _register();
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: _adding ?
                      const CircularProgressIndicator() :
                      _justAddedUser != null ?
                      const Text(
                          'Congratulazione! Utente aggiunto con successo' //TODO cambiare in modo da far apparire un riepilogo dell'utente
                      ) :
                      const SizedBox.shrink(), //rappresenta uno spazio vuoto senza dimensioni
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _register() {
    setState(() {
      _adding = true;
      _justAddedUser = null;
    });



    if ( _userNameFiledController.text == null || _userNameFiledController.text == "" ||
        _firstNameFiledController.text == null || _firstNameFiledController.text == "" ||
        _lastNameFiledController.text == null || _lastNameFiledController.text == "" ||
        _codeFiledController.text == null || _codeFiledController.text == "" ||
        _telephoneNumberFiledController.text == null || _telephoneNumberFiledController.text == "" ||
        _emailFiledController.text == null || _emailFiledController.text == "" ||
        _addressFiledController.text == null || _addressFiledController.text == "" ||
        _passwordFiledController.text == null || _passwordFiledController.text == "" ) {

      showDialog(
        context: context,
        builder: (context) => const MessageDialog(
          titleText: "Ops ... ",
          bodyText: "Campi non validi",
        ),
      );
      setState(() {
        _adding = false;
      });
      return;
    }

    if(_confermaPasswordFiledController.text != _passwordFiledController.text){
      showDialog(
        context: context,
        builder: (context) => const MessageDialog(
          titleText: "Ops ... ",
          bodyText: "Le password inserite non coincidono",
        ),
      );
      setState(() {
        _adding = false;
      });
      return;
    }

    User user = User(
        username: _userNameFiledController.text,
        firstName: _firstNameFiledController.text,
        lastName: _lastNameFiledController.text,
        code: _codeFiledController.text,
        telephoneNumber: _telephoneNumberFiledController.text,
        email: _emailFiledController.text,
        address: _addressFiledController.text,
        password: _passwordFiledController.text);

    Model.sharedInstance.addUser(user)?.then((result) {
      setState(() {
        _adding = false;
        _justAddedUser = result;
      });
    });
  }
}


