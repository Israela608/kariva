class AppConstants {
  static const String APP_NAME = 'Kariva';
  static const int APP_VERSION = 1;

  //URL is the locator, URI is the identifier
  //static const String BASE_URL = 'http://mvs.bslmeiyu.com';
  //static const String BASE_URL = 'http://127.0.0.1:8000';
  //static const String BASE_URL = 'http://10.0.2.2:8000';
  static const String BASE_URL = 'http://192.168.43.186:8000';
  static const String POPULAR_PRODUCT_URI = '/api/v1/products/popular';
  static const String RECOMMENDED_PRODUCT_URI = '/api/v1/products/recommended';
  //static const String DRINKS_URI = '/api/v1/products/drinks';
  static const String UPLOAD_URL = '/uploads/';

  //auth and user end points
  static const String REGISTRATION_URI = '/api/v1/auth/register';
  static const String LOGIN_URI = '/api/v1/auth/login';
  static const String USER_INFO_URI = '/api/v1/customer/info';
  static const String ADD_USER_ADDRESS_URI = '/api/v1/customer/address/add';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';

  //config end points
  static const String GEOCODE_URI = '/api/v1/config/geocode-api';
  static const String ZONE_URI = '/api/v1/config/get-zone-id';
  static const String SEARCH_LOCATION_URI =
      '/api/v1/config/place-api-autocomplete';
  static const String PLACE_DETAILS_URI = '/api/v1/config/place-api-details';

  //order end points
  static const String PLACE_ORDER_URI = '/api/v1/customer/order/place';
  static const String ORDER_LIST_URI = '/api/v1/customer/order/list';

  static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
/*
   The Backend

   http://127.0.0.1:8000/     is the domain name or base url
   App/Http/Controllers/    is the namespace which is added automatically by the end point in the api_client
   api/v1/    is added after the namespace
   products is the prefix
   popular is the endpoint. It locates the PopularController.php file and returns the get_popular_products() function

   http://127.0.0.1:8000/App/Http/Controllers/api/v1/products/popular
*/

  static const String TOKEN = 'token';
  static const String PHONE = 'phone';
  static const String PASSWORD = 'password';
  //Key for our Cart list in Shared Preferences
  static const String CART_LIST = 'cart-list';
  static const String CART_HISTORY_LIST = 'cart-history-list';

  static const String USER_ADDRESS = 'user_address';
}
