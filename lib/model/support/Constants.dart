class Constants {
  // app info
  static const String APP_VERSION = "0.0.1";
  static const String APP_NAME = "Frontend-store";

  // addresses
  static const String ADDRESS_STORE_SERVER = "localhost:8080";
  static const String ADDRESS_AUTHENTICATION_SERVER = "localhost:8180";

  // authentication
  static const String REALM = "realm_prog";
  static const String CLIENT_ID = "server-store";
  static const String CLIENT_SECRET = "nuMDmf301DJgDJrx8UvCIoW47BWl8rv8";
  static const String REQUEST_LOGIN = "/realms/$REALM/protocol/openid-connect/token";
  static const String REQUEST_LOGOUT = "/realms/$REALM/protocol/openid-connect/logout";

  // requests
  static const String REQUEST_SEARCH_PRODUCTS = "/products/search/by_name";
  static const String REQUEST_ADD_USER = "/users";

  // states


  // responses
  static const String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "ERROR_MAIL_USER_ALREADY_EXISTS";

  // messages
  static const String MESSAGE_CONNECTION_ERROR = "connection_error";

  // links
  static const String LINK_RESET_PASSWORD = "***";
  static const String LINK_FIRST_SETUP_PASSWORD = "***";


}