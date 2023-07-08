import 'package:flutter/material.dart';

import '../../Model.dart';
import '../../support/LogInResult.dart';
import '../widget/button/ExpandableLoginButton.dart';
import '../widget/dialog/MessageDialog.dart';

/*
  Navigator.of(context).push( //permette di posizionare al di sopra della pagina in cui ci troviamo un'altra pagina
    PageRouteBuilder(
    opaque: false,
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (BuildContext context, _, __) => const Home()
  ),
);

 */
class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clicca sul seguente bottone per procedere"),
      ),
      body: Stack(
        children: [
          _isLoading ?
          const Center(
            child: CircularProgressIndicator(),
          ) :
          //Se _isLoading è false si procede con il seguente codice
          const Padding(padding: EdgeInsets.all(0)),
          SingleChildScrollView(
            child: IgnorePointer( //il bottone non puo' piu' essere cliccato
              ignoring: _isLoading,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    ),
                    ExpandableLogInButton(
                      textOuterButton: "Mostra",
                      onSubmit: (String email, String password) async {
                        //Nonostante ci siano due chiamate a setState nello stesso metodo, Flutter ottimizza l'esecuzione effettuandone solo una
                        setState(() { // il codice all'interno di setState viene automaticamente postato nel thread principale per garantire che le modifiche dello stato vengano eseguite in modo sicuro e coerente con l'interfaccia utente
                          _isLoading = true;
                        });
                        if ( email == null || email == "" || password == null || password == "" ) {
                          showDialog(
                            context: context,
                            builder: (context) => const MessageDialog(
                              titleText: "Ops ... ",
                              bodyText: "Campi non validi",
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }

                        if(Model.sharedInstance.isLogged()){
                          showDialog(
                            context: context,
                            builder: (context) => const MessageDialog(
                              titleText: "Ops ... ",
                              bodyText: "Sei gia' loggato",
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }

                        LogInResult result = await Model.sharedInstance.logIn(email, password);
                        setState(() {
                          _isLoading = false;
                        });
                        if ( result == LogInResult.logged ) {
                          showDialog(
                            context: context,
                            builder: (context) => const MessageDialog(
                              titleText: "Loggato con successo",
                              bodyText: "",
                            ),
                          );
                        }
                        else if ( result == LogInResult.error_wrong_credentials ) {
                          showDialog(
                            context: context,
                            builder: (context) => const MessageDialog(
                              titleText: "Ops ... ",
                              bodyText: "Username o password scorretti",
                            ),
                          );
                        }
                        else if ( result == LogInResult.error_connection_failed ) {
                          showDialog(
                            context: context,
                            builder: (context) => const MessageDialog(
                              titleText: "Ops ... ",
                              bodyText: "Sistema attualmente non raggiungibile. Riprova piu' tardi.",
                            ),
                          );
                        }
                        else {
                          showDialog(
                            context: context,
                            builder: (context) => const MessageDialog(
                              titleText: "Ops ... ",
                              bodyText: "Errore sconosciuto. Ritenta piu' tardi",
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
