class Constants {
  // app info
  static const String APP_VERSION = "0.0.1";
  static const String APP_NAME = "Frontend-store";

  // addresses
  static const String ADDRESS_STORE_SERVER = "localhost:9190";
  static const String ADDRESS_AUTHENTICATION_SERVER = "localhost:8180";

  // auth_keycloak
  static const String REALM = "realm_prog";
  static const String CLIENT_ID = "server-store";
  static const String CLIENT_SECRET = "nuMDmf301DJgDJrx8UvCIoW47BWl8rv8";
  static const String REQUEST_LOGIN = "/realms/$REALM/protocol/openid-connect/token";
  static const String REQUEST_LOGOUT = "/realms/$REALM/protocol/openid-connect/logout";

  // auth_backend
  static const String REQUEST_ADD_USER = "/manage/addUser";

  // Requests back-end
  //Product
  static const String REQUEST_SEARCH_PRODUCTS_PAGED = "/products/paged";
  static const String REQUEST_SEARCH_PRODUCTS_BY_NAME = "/products/search_by_name";

  //Cart da loggato
  static const String GET_CART = "/cart/get";
  static const String ADD_PROD_TO_CART = "/cart/addProd";
  static const String ADD_ALL_PROD_TO_CART = "/cart/addAllProd";
  static const String REMOVE_PROD_FROM_CART = "/cart/removeProd";
  static const String REMOVE_ALL_PROD_FROM_CART = "/cart/removeAllProd";
  static const String PLUS_PROD_OF_CART = "/cart/plusQntProd";
  static const String MINUS_PROD_OF_CART = "/cart/minusQntProd";
  //Relative response from server
  static const String RESPONSE_OK = "OK";
  static const String RESPONSE_ERROR_USERNAME_NOT_FOUND = "USERNAME_NOT_FOUND";
  static const String RESPONSE_ERROR_INNER_ERROR_TRY_LATER = "INNER_ERROR_TRY_LATER";
  static const String RESPONSE_ERROR_PRODUCT_NOT_EXIST = "PRODUCT_NOT_EXIST";
  static const String RESPONSE_ERROR_PRODUCT_IN_PURCHASE_NOT_EXIST_IN_CART = "PRODUCT_IN_PURCHASE_NOT_EXIST_IN_CART";

  //Purchase da loggato
  static const String ADD_PURCHASE = "/purchase";
  static const String GET_PURCHASE = "$ADD_PURCHASE/purchases";
  //Relative response from server
  static const String RESPONSE_ERROR_INTERNAL_ERROR_TRY_LATER = "INTERNAL_ERROR_TRY_LATER";
  static const String RESPONSE_ERROR_PRODUCT = "PRODUCT";

  // responses server
  static const String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "EMAIL_ALREADY_IN_USE";
  static const String RESPONSE_ERROR_USERNAME_ALREADY_EXISTS = "USERNAME_ALREADY_IN_USE";
  static const String RESPONSE_ERROR_SERVER_ERROR = "SERVER_ERROR";

  // messages
  static const String MESSAGE_CONNECTION_ERROR = "connection_error"; //ritenta nuova connessione
  static const String CONNECTION_FAILED = "connection_failed"; //tentativi falliti



}