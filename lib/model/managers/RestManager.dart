import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

import '../support/Constants.dart';
import '../support/ErrorListener.dart';


enum TypeHeader {
  json,
  urlencoded
}


class RestManager {
  ErrorListener? delegate; //rappresenta l'interfaccia grafica -> separazione tra logica di business e interfaccia grafica. Il delegate potrebbe anche non essere passato infatti si verifica se sia null prima di invocare metodi.
  String? token;
  static const int NUMBER_OF_REQUEST_TO_AUTH_SERVER = 2;


  /// Se https=true allora viene invocata una chiamata https.
  /// Dopo il parametro "TypeHeader type" possiamo ricevere "Map<String, String>? value" oppure "dynamic body".
  /// "value" si riferisce alla mappa dei query param, "body" invece si riferisce alla mappa del body.
  Future<String> _makeRequest(String serverAddress, String servicePath, String method, TypeHeader type, bool https, {Map<String, String>? value, dynamic body}) async { //dopo il parametro "TypeHeader type" possiamo ricevere "Map<String, String>? value" oppure "dynamic body"
    Uri uri;
    if(https) {
      uri = Uri.https(serverAddress, servicePath, value);
    } else {
      uri = Uri.http(serverAddress, servicePath, value);
    }
    bool errorOccurred = false;
    for(int i=0; i<NUMBER_OF_REQUEST_TO_AUTH_SERVER; i++) { //il seguente codice prova a fare la richiesta, e nel caso di errori aspetta 5 secondi e riparte di nuovo
      try {
        var response; //risposta della richiesta. Una volta assegnato un oggetto di un certo tipo, quello stesso tipo deve essere mantenuto (vantaggio di utilizzare l'interfaccia di quel tipo dopo la prima inizializzazione)
        // setting content type
        String contentType = "";
        dynamic formattedBody; //Puo' essere cambiato il tipo dell'oggetto che gli passiamo (lo svantaggio e' che non possiamo sfruttare l'interfaccia di quel tipo assegnato dato che potrebbe cambiare)
        if ( type == TypeHeader.json ) {
          contentType = "application/json;charset=utf-8";
          formattedBody = json.encode(body);
        }
        else if ( type == TypeHeader.urlencoded ) {
          contentType = "application/x-www-form-urlencoded";
          formattedBody = body.keys.map((key) => "$key=${body[key]}").join("&");
        }
        // setting headers
        Map<String, String> headers = Map();
        headers[HttpHeaders.contentTypeHeader] = contentType;
        if ( token != null ) {
          headers[HttpHeaders.authorizationHeader] = 'bearer $token';
        }
        // making request
        switch ( method ) {
          case "post":
            response = await post(
              uri,
              headers: headers,
              body: formattedBody,
            );
            break;
          case "get":
            response = await get(
              uri,
              headers: headers,
            );
            break;
          case "put":
            response = await put(
              uri,
              headers: headers,
            );
            break;
          case "delete":
            response = await delete(
              uri,
              headers: headers,
            );
            break;
        }
        if ( delegate != null && errorOccurred ) {
          delegate!.errorNetworkGone();
          errorOccurred = false;
        }
        return response.body;
      } catch(err) {
        if ( delegate != null && !errorOccurred ) {
          delegate!.errorNetworkOccurred(Constants.MESSAGE_CONNECTION_ERROR);
          errorOccurred = true;
        }
        await Future.delayed(const Duration(seconds: 5), () => null);
      }
    }
    delegate!.errorNetworkOccurred(Constants.CONNECTION_FAILED);
    return "";
  }

  Future<String> makePostRequest(String serverAddress, String servicePath, bool https, dynamic value, { TypeHeader type = TypeHeader.json} ) async {
    return _makeRequest(serverAddress, servicePath, "post", type, https, body: value);
  }

  Future<String> makeGetRequest(String serverAddress, String servicePath, bool https, [Map<String, String>? value, TypeHeader type = TypeHeader.json]) async {
    return _makeRequest(serverAddress, servicePath, "get", type, https, value: value);
  }

  Future<String> makePutRequest(String serverAddress, String servicePath, bool https, [Map<String, String>? value, TypeHeader type = TypeHeader.json]) async {
    return _makeRequest(serverAddress, servicePath, "put", type, https, value: value);
  }

  Future<String> makeDeleteRequest(String serverAddress, String servicePath, bool https, [Map<String, String>? value, TypeHeader type = TypeHeader.json]) async {
    return _makeRequest(serverAddress, servicePath, "delete", type, https, value: value);
  }


}
