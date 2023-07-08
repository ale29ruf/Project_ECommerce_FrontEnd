import 'dart:async';
import 'dart:convert';

import 'package:project_ecommerce/model/objects/ProductInPurchase.dart';
import 'package:project_ecommerce/model/support/Communicator.dart';
import 'package:project_ecommerce/model/support/Constants.dart';
import 'package:project_ecommerce/model/support/LogInResult.dart';
import 'package:project_ecommerce/model/support/ProductSortBy.dart';

import 'managers/RestManager.dart';
import 'objects/AuthenticationData.dart';
import 'objects/Message.dart';
import 'objects/Product.dart';
import 'objects/Purchase.dart';
import 'objects/User.dart';


class Model {  //usata per effettuare chiamate http
  static Model sharedInstance = Model(); //classe singleton. Ovviamente non e' vietato dall'esterno invocare il costruttore della classe

  final RestManager _restManager = RestManager();
  AuthenticationData? _authenticationData;

  bool logged = false;

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

      logged = true;
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
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async {
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken!;
      await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGOUT, false, params, type: TypeHeader.urlencoded);
      logged = false;
      Communicator.sharedInstance.reset();
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

  Future<List<Product>?>? searchProductPaged(int pageNumber, int pageSize, {ProductSortBy orderBy = ProductSortBy.id}) async {
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

  Future<List<ProductInPurchase>?>? getCart() async {
    try {
      return List<ProductInPurchase>.from(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.GET_CART, true)).map((i) => ProductInPurchase.fromJson(i)).toList());
    }
    catch (e) {
      List<ProductInPurchase> response = [];
      return response;
    }
  }

  Future<Message?>? addProductToCart(int id) async { //Si presume che il prodotto ottenuto sia uno
    Map<String, String> params = Map();
    params["idProd"] = '$id';
    try {
      return Message.fromJson(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.ADD_PROD_TO_CART, true, params)));
    }
    catch (e) {
      return null;
    }
  }

  // Possiamo passare direttamente la lista al metodo makePostRequest perchè tanto il metodo json.encode in _makeRequest del RestManager si occupa di invocare dietro le quinte toJson sugli elementi della lista
  Future<Message?>? addAllProductToCart(List<ProductInPurchase> list) async {
    try {
      return Message.fromJson(json.decode(await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.ADD_ALL_PROD_TO_CART, true, list)));
    }
    catch (e) {
      return null;
    }
  }

  Future<Message?>? removeProductFromCart(int id) async { //Si presume che il prodotto ottenuto sia uno
    Map<String, String> params = Map();
    params["idProd"] = '$id';
    try {
      return Message.fromJson(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REMOVE_PROD_FROM_CART, true, params)));
    }
    catch (e) {
      return null;
    }
  }

  Future<Message?>? removeAllProductFromCart() async {
    try {
      return Message.fromJson(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REMOVE_ALL_PROD_FROM_CART, true)));
    }
    catch (e) {
      return null;
    }
  }

  Future<Message?>? plusProductOfCart(int id) async { //Si presume che il prodotto ottenuto sia uno
    Map<String, String> params = Map();
    params["idProd"] = '$id';
    try {
      return Message.fromJson(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.PLUS_PROD_OF_CART, true, params)));
    }
    catch (e) {
      return null;
    }
  }

  Future<Message?>? minusProductOfCart(int id) async { //Si presume che il prodotto ottenuto sia uno
    Map<String, String> params = Map();
    params["idProd"] = '$id';
    try {
      return Message.fromJson(json.decode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.MINUS_PROD_OF_CART, true, params)));
    }
    catch (e) {
      return null;
    }
  }

  Future<Purchase?>? createPurchase(List<ProductInPurchase> list) async {
    try {
      return Purchase.fromJson(json.decode(await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.ADD_PURCHASE, true, list)));
    }
    catch (e) {
      return null;
    }
  }



  bool isLogged() {
    return logged;
  }

}

