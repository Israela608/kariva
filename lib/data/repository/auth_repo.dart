import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:kariva/data/api/api_client.dart';
import 'package:kariva/models/signup_body_model.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  AuthRepo({required this.apiClient, required this.sharedPreferences});
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  //Method for posting registration data to the server through the ApiClient
  //We use the end-point of the uri here, and also the data we are sending
  Future<Response> registration(SignUpModel signUpModel) async {
    return await apiClient.postData(
        AppConstants.REGISTRATION_URI, signUpModel.toJson());
  }

  Future<Response> login(String phone, String password) async {
    //Auto convert the email and password to json
    return await apiClient.postData(
        AppConstants.LOGIN_URI, {"phone": phone, "password": password});
  }

  //Method that saves the user token from the server, so we can use it next time we log in
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    //Save the token to shared preferences with key as AppConstants.TOKEN
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  //Method that saves the user phone number and password, so we can use it next time we log in
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.PHONE, number);
      await sharedPreferences.setString(AppConstants.PASSWORD, password);
    } catch (e) {
      rethrow;
    }
  }

  //Method that gets the user token
  Future<String> getUserToken() async {
    // AppConstants.TOKEN is the key to get the saved token
    return await sharedPreferences.getString(AppConstants.TOKEN) ?? 'None';
  }

  // Checks if there is a user token available
  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  //Clear all login data
  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PHONE);
    sharedPreferences.remove(AppConstants.PASSWORD);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }

  //Method that posts the updated user device firebase token to the server
  Future<Response> updateToken() async {
    String? _deviceToken;

    //If device is IOS
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      //Request permission for the parameters that are true
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
        print('My token is  ' + _deviceToken!);
      }
    } //If device is android
    else {
      _deviceToken = await _saveDeviceToken();
      print('My token is  ' + _deviceToken!);
    }

    if (!GetPlatform.isWeb) {
      //FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }

    return await apiClient.postData(AppConstants.TOKEN_URI,
        {'_method': 'put', 'cm_firebase_token': _deviceToken});
  }

  //Method that gets and returns the device firebase token
  Future<String?> _saveDeviceToken() async {
    String? _deviceToken = '@';

    //If Android or IOS
    if (!GetPlatform.isWeb) {
      try {
        FirebaseMessaging.instance.requestPermission();
        _deviceToken = await FirebaseMessaging.instance.getToken();
        //await FirebaseMessaging.registerForRemoteNotifications();
      } catch (e) {
        print('could not get the token');
        print(e.toString());
      }
    }

    if (_deviceToken != null) {
      print('----------Device Token----------' + _deviceToken);
    }

    return _deviceToken;
  }
}
