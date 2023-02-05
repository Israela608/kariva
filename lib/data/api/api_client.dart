import 'dart:developer';

import 'package:get/get.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl; //The server url
  late SharedPreferences sharedPreferences;

  //Map is for storing data locally
  //Lists are wrapped around [], Maps are wrapped around {}
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl; //baseUrl is from the GetX package.
    timeout = const Duration(seconds: 30);
    //token = AppConstants.TOKEN;
    //Assign the token to the saved user token. If the user has not signed up then token is empty
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? '';
    //Headers are very important for Get or Post requests
    //In this case for Get request, you're telling the server to send you json data
    //For post request, the server knows that you're sending it json data
    //Charset is the encoding and decoding format. It's not really that important
    //token is important for post request. Bearer is the token type. The token key is used for getting authorization from the server
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  //Method that Updates the header automatically with the real token from the server.
  //Next time when the user logs in, the information will be saved with the token
  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  //Get method. For getting data from the server
  //Response is from the getX package. We use getX client instead of http client from http package
  //Note that getX uses http internally
  //GetX returns a response which is your data and the type is Response
  //Headers is not compulsory for all get requests, only for some that needs verification.
  //When you wrap thing arguments around curly braces, they become optional. That's why we need required keyword of you want arguments in a curly braces to be required
  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      //The end point
      //get the data from the uri. If there's no header, then use _mainHeaders
      Response response = await get(uri, headers: headers ?? _mainHeaders);
      print('GET API RESPONSE:   ' + response.body.toString());
      //log('GET API RESPONSE:   ' + response.body.toString());
      //print('TOKEN   ' + token);
      return response; //return the data
    } catch (e) {
      return Response(
          statusCode: 1, statusText: e.toString()); //return error message
    }
  }

  //Post method
  Future<Response> postData(String uri, dynamic body) async {
    log('POST BODY:   ' + body.toString());
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      print('POST API RESPONSE:   ' + response.toString());
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
