import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kariva/data/api/api_client.dart';
import 'package:kariva/models/address_model.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  LocationRepo({required this.apiClient, required this.sharedPreferences});
  ApiClient apiClient;
  SharedPreferences sharedPreferences;

  //Method that sends the latitude and longitude positions to the server and returns the address data from the server
  Future<Response> getAddressFromGeocode(LatLng latLng) async {
    //Send the latitude and longitude to the server uri and get the response
    return await apiClient.getData('${AppConstants.GEOCODE_URI}'
        '?lat=${latLng.latitude}&lng=${latLng.longitude}');
  }

  //Method that returns the stored user address. If there's no address return empty String
  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS) ?? '';
  }

  //Method that posts and stores a chosen address to the server
  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.postData(
        AppConstants.ADD_USER_ADDRESS_URI, addressModel.toJson());
  }

  //Method that gets the list of all the addresses stored in the database
  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

  //Method that saves the address to local storage
  Future<bool> saveUserAddress(String userAddress) async {
    //since the user has to be logged in to use this method, we update the header to validate the authentication
    //In case a new user is logged in, we replace the old token with the token of the new user
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return await sharedPreferences.setString(
        AppConstants.USER_ADDRESS, userAddress);
  }

  //Method that sends the location of the user to the server
  // to check if the use location matches the zone where the service is available
  Future<Response> getZone(String lat, String lng) async {
    return await apiClient
        .getData('${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }

  //Method that sends a searched text to the server and get a response
  Future<Response> searchLocation(String text) async {
    return await apiClient
        .getData('${AppConstants.SEARCH_LOCATION_URI}?search_text=$text');
  }

  //Method that sends the placeID of a particular location to the server and gets more information about the location
  Future<Response> setLocation(String placeID) async {
    return await apiClient
        .getData('${AppConstants.PLACE_DETAILS_URI}?placeid=$placeID');
  }
}
