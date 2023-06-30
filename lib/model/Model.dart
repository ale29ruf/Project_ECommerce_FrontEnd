import 'dart:async';
import 'dart:convert';

import 'package:project_ecommerce/model/support/Constants.dart';
import 'package:project_ecommerce/model/support/LogInResult.dart';
import 'package:project_ecommerce/model/support/ProductSortBy.dart';

import 'managers/RestManager.dart';
import 'objects/AuthenticationData.dart';
import 'objects/Product.dart';
import 'objects/User.dart';


class Model {  //usata per effettuare chiamate http
  static Model sharedInstance = Model(); //classe singleton. Ovviamente non e' vietato dall'esterno invocare il costruttore della classe
  bool logged = false;

  final RestManager _restManager = RestManager();
  AuthenticationData? _authenticationData;

  /// I metodi dichiarati come async in Dart dovrebbero sempre restituire un oggetto Future. L'uso di async indica che il metodo contiene operazioni
  /// asincrone, che potrebbero richiedere del tempo per essere completate. Restituendo un oggetto Future, si permette al chiamante del metodo di gestire
  /// il risultato o gli errori dell'operazione asincrona in modo appropriato.
  /// Un oggetto Future rappresenta un valore o un'eccezione che potrebbe non essere ancora disponibile. Può essere considerato come una promessa che
  /// verrà soddisfatta in futuro. Il valore restituito dal metodo async verrà incapsulato in un oggetto Future e sarà accessibile una volta che
  /// l'operazione asincrona sarà stata completata.

  Future<LogInResult> logIn(String email, String password) async { //Il risultato del metodo puo' essere restituito dopo un certo tempo, per questo restituiamo un Future
    try{                                                          //async wrappa in automatico il tipo di ritorno in un Future<LogInResult>
      Map<String, String> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, false, params, type: TypeHeader.urlencoded); //operazione bloccante
      if(result == ""){
        return LogInResult.error_connection_failed;
      }
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData!.hasError() ) {
        //Gestione degli errori di keycloak
        if ( _authenticationData!.error == "Invalid user credentials" ) {
          return LogInResult.error_wrong_credentials;
        }
        else if ( _authenticationData!.error == "Account is not fully set up" ) {
          return LogInResult.error_not_fully_setupped;
        }
        else {
          return LogInResult.error_unknown;
        }
      }
      _restManager.token = _authenticationData!.accessToken;
      Timer.periodic(Duration(seconds: (_authenticationData!.expiresIn! - 50)), (Timer t) { //Effettua il refresh in automatico del token 50 secondi prima che scada
        _refreshToken();
      });
      return LogInResult.logged;
    }
    catch (e) {
      return LogInResult.error_unknown;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken!;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, false, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData!.hasError() ) {
        return false;
      }
      _restManager.token = _authenticationData!.accessToken;
      logged = true;
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async { //TODO
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken!;
      await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGOUT, false, params, type: TypeHeader.urlencoded);
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<User?> addUser(User user) async {
    try {
      String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_USER, true, user);
      if(rawResult == ""){ //tentavi di connessione al server scaduti
        return null;
      }
      return User.fromJson(jsonDecode(rawResult));
    }
    catch (e) { //errore interno al server (potrebbe essere causato anche dal parsing)
      return null;
    }
  }

  Future<List<Product>?>? searchProduct(String name) async { //Si presume che il prodotto ottenuto sia uno
    Map<String, String> params = Map();
    params["name"] = name;
    try {
      return List<Product>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_PRODUCTS_BY_NAME, true, params)).map((i) => Product.fromJson(i)).toList());
    }                                                                               //per ogni valore nel risultato, viene convertito in un oggetto Product e alla fine di tutta l'operazione convertiamo l'insieme di oggetti in una lista
    catch (e) {
      List<Product> response = [];
      return response;
    }
  }

  Future<List<Product>?>? _searchProductPaged(int pageNumber, int pageSize, {ProductSortBy orderBy = ProductSortBy.id}) async {
    Map<String, String> params = {};
    params["pageNumber"] = pageNumber.toString();
    params["pageSize"] = pageSize.toString();
    if(orderBy == ProductSortBy.name) {
      params["sortBy"] = "name";
    }else if (orderBy == ProductSortBy.price){
      params["sortBy"] = "price";
    } else {
      params["sortBy"] = "id";
    }
    try {
      return List<Product>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_PRODUCTS_PAGED, true, params)).map((i) => Product.fromJson(i)).toList());
    }                                                                               //per ogni valore nel risultato, viene convertito in un oggetto Product e alla fine di tutta l'operazione convertiamo l'insieme di oggetti in una lista
    catch (e) {
      List<Product> response = [];
      return response;
    }
  }

  Future<List<Product>?>? searchProductPagedByName(int pageNumber, int pageSize) async {
    return _searchProductPaged(pageNumber,pageSize,orderBy: ProductSortBy.name);
  }

  Future<List<Product>?>? searchProductPagedByPrice(int pageNumber, int pageSize) async {
    return _searchProductPaged(pageNumber,pageSize,orderBy: ProductSortBy.price);
  }

  Future<List<Product>?>? searchProductPaged(int pageNumber, int pageSize) async {
    return _searchProductPaged(pageNumber,pageSize,orderBy: ProductSortBy.id);
  }

}
