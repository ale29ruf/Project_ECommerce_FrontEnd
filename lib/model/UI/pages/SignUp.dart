import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model.dart';
import '../../objects/User.dart';
import '../../support/Constants.dart';
import '../widget/InputField.dart';
import '../widget/button/CircularIconButton.dart';
import '../widget/button/StadiumButton.dart';
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
        child: Center(
          child: Column( //figlio scrollabile
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                'Inserisci le informazioni negli appositi spazi',
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  SizedBox(
                      width: 300,
                      child: InputField(
                        labelText: "Username",
                        controller: _userNameFiledController, //ogni campo di testo ha il proprio controller
                    )
                  ),
                  SizedBox(
                      width: 300,
                      child: InputField(
                          labelText: "Nome",
                          controller: _firstNameFiledController, //ogni campo di testo ha il proprio controller
                        )
                  ),
                  SizedBox(
                    width: 300,
                    child: InputField(
                      labelText: "Cognome",
                      controller: _lastNameFiledController,
                    ),
                  ),
                  SizedBox(
                      width: 300,
                      child: InputField(
                        labelText: "Codice fiscale",
                        controller: _codeFiledController,
                      )
                  ),
                  SizedBox(
                    width: 300,
                    child: InputField(
                      labelText: "Numero telefonico",
                      controller: _telephoneNumberFiledController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: InputField(
                      labelText: "E-mail",
                      controller: _emailFiledController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: InputField(
                      labelText: "Indirizzo",
                      controller: _addressFiledController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: InputField(
                      labelText: "Password",
                      isPassword: true,
                      controller: _passwordFiledController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: InputField(
                      labelText: "Conferma password",
                      isPassword: true,
                      controller: _confermaPasswordFiledController,
                    ),
                  ),
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
                        StadiumButton(
                          icon: Icons.access_alarms_sharp,
                          title: "Mostra esito",
                          onPressed: () {
                            String response = _createResponse();
                            showDialog(
                              context: context,
                              builder: (context) => MessageDialog(
                                titleText: response,
                                bodyText:
                                !_justAddedUser!.hasError() ?
                                  "Username: ${_justAddedUser!.username} \n Email: ${_justAddedUser!.email}"  : ""
                              ),
                            );
                          },
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
      ),
    );
  }

  String _createResponse(){
    String response = "";
    if(_justAddedUser!.message != null){
      if(_justAddedUser!.message == Constants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS){
        response = "E-mail inserita già esistente \n Riprova";
      } else if (_justAddedUser!.message == Constants.RESPONSE_ERROR_USERNAME_ALREADY_EXISTS){
        response = "Username inserito già esistente \n Riprova";
      }
    } else {
      response = "Utente registrato correttamente";
    }
    return response;
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
        codFiscale: _codeFiledController.text,
        telephoneNumber: _telephoneNumberFiledController.text,
        email: _emailFiledController.text,
        address: _addressFiledController.text,
        password: _passwordFiledController.text);

    Model.sharedInstance.addUser(user).then((result) {
      if(result == null){
        _justAddedUser = User(username: "username", codFiscale: "codFiscale", firstName: "firstName", lastName: "lastName", telephoneNumber: "telephoneNumber", email: "email", address: "address", password: "password");
        _justAddedUser?.message = "Server offline \n Riprovare piu' tardi";
      } else {
        _justAddedUser = result ;
      }
      setState(() {
        _adding = false;
      });
    });
  }
}


