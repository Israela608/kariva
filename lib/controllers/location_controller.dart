import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';
import 'package:kariva/data/api/api_checker.dart';
import 'package:kariva/data/repository/location_repo.dart';
import 'package:kariva/models/address_model.dart';
import 'package:kariva/models/response_model.dart';

class LocationController extends GetxController implements GetxService {
  LocationController({required this.locationRepo});
  final LocationRepo locationRepo;

  bool _loading = false;
  late Position _position;
  Position? _pickPosition;
  //Placemark can identify each of the properties of a String address. Like country, postal code, street, etc
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  //List of all the addresses stored in the server
  List<AddressModel> _addressList = [];
  late List<AddressModel> _allAddressList;
  final List<String> _addressTypeList = ['home', 'office', 'others'];
  int _addressTypeIndex = 0;
  late Map<String, dynamic> _getAddress;
  late GoogleMapController _mapController;
  bool _updateAddressData = true;
  bool _changeAddress = true;

  //For service zone
  bool _isLoading = false;
  //Whether the user is in service zone or not
  bool _inZone = false;
  //Showing and hiding the button as the map loads
  bool _buttonDisabled = true;

  //Save the google map suggestions for the address
  List<Prediction> _predictionList = [];

  List<AddressModel> get addressList => _addressList;
  List<AddressModel> get allAddressList => _allAddressList;
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;
  Map get getAddress => _getAddress;
  bool get loading => _loading;
  Position get position => _position;
  Position? get pickPosition => _pickPosition;
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  GoogleMapController get mapController => _mapController;

  bool get isLoading => _isLoading;
  bool get inZone => _inZone;
  bool get buttonDisabled => _buttonDisabled;

  //Method for setting the map controller
  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  //Method that updates the position, address and placeMark parameters from the screen that map
  Future<void> updatePosition(
      CameraPosition position, bool fromAddAddressPage) async {
    //If we can update the position data
    if (_updateAddressData) {
      _loading = true;
      update();

      try {
        //Method is called from addAddressPage
        if (fromAddAddressPage) {
          _position = Position(
            longitude: position.target.longitude,
            latitude: position.target.latitude,
            timestamp: DateTime.now(),
            accuracy: 1,
            altitude: 1,
            heading: 1,
            speed: 1,
            speedAccuracy: 1,
          );
        } else {
          //Method is called from pickAddressMap page, etc
          _pickPosition = Position(
            longitude: position.target.longitude,
            latitude: position.target.latitude,
            timestamp: DateTime.now(),
            accuracy: 1,
            altitude: 1,
            heading: 1,
            speed: 1,
            speedAccuracy: 1,
          );
        }

        ResponseModel _responseModel = await getZone(
          position.target.latitude.toString(),
          position.target.longitude.toString(),
          false,
        );

        // If the responseModel is successful (isSuccess is true), then our button is enabled
        // If buttonDisabled value is false (button is enabled), we are in the service area
        _buttonDisabled = !_responseModel.isSuccess;

        if (_changeAddress) {
          String _address = await getAddressFromGeocode(LatLng(
            position.target.latitude,
            position.target.longitude,
          ));

          //If this updatePosition() method is called from the AddAddressPage
          fromAddAddressPage
              ? _placemark = Placemark(name: _address)
              : _pickPlacemark = Placemark(name: _address);
        } else {
          _changeAddress = true;
        }
      } catch (e) {
        print(e);
      }

      _loading = false;
      update();
    } else {
      //Else
      //We can now update the position data
      _updateAddressData = true;
    }
  }

  //Method that sends the latitude and longitude positions to the server and returns the address from the server
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String _address = 'Unknown Location Found';
    Response response = await locationRepo.getAddressFromGeocode(latLng);
    if (response.body['status'] == 'OK') {
      _address = response.body['results'][0]['formatted_address'].toString();
      print('printing address   ' + _address);
    } else {
      print('Error getting the google api');
    }

    update();
    return _address;
  }

  //Method that returns the stored user address
  AddressModel getUserAddress() {
    late AddressModel _addressModel;

    //Decode the stored String address to Map using jsonDecode
    _getAddress = jsonDecode(locationRepo.getUserAddress());

    try {
      _addressModel =
          AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    } catch (e) {
      print(e);
    }

    return _addressModel;
  }

  //Method that sets the address type (home, office, others) and updates the ui
  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  //Method that saves a chosen address to the server
  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();

    //Save the address and get the response
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;

    //If saved successfully
    if (response.statusCode == 200) {
      //Get the list of addresses from the server, including the one we just saved -> For future usage
      await getAddressList();
      String message = response.body['message'];
      responseModel = ResponseModel(true, message);
      //Save the address in local storage. Or if an address was saved previously, replace that address.
      await saveUserAddress(addressModel);
    } else {
      print("Couldn't save the address");
      responseModel = ResponseModel(false, response.statusText!);
    }

    _loading = false;
    update();
    return responseModel;
  }

  //Method that gets the list of all the addresses stored in the database
  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();

    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];

      //Loop through the response from the database and add it to our lists
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }

    update();
  }

  //Method that saves the address to local storage
  Future<bool> saveUserAddress(AddressModel addressModel) async {
    //By converting our addressModel object to Json, it will make it easier to Encode
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  //Method that gets the stored user address from local storage
  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }

  //Method that clear our list of addresses during logout
  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  //Method that sets the position ad placemark parameters to be the same irrespective of the page that it's called.
  void setAddAddressData() {
    _position = _pickPosition!;
    _placemark = _pickPlacemark;
    //Make sure the updatePosition method does not work, since we have set the address from the screen already
    _updateAddressData = false;
    update();
  }

  //Method that checks if the use location matches the zone where the service is available
  Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _responseModel;

    markerLoad ? _loading = true : _isLoading = true;
    update();

    Response response = await locationRepo.getZone(lat, lng);

    //If the user is in the zone of service
    if (response.statusCode == 200) {
      _inZone = true;

      //To prevent errors, convert the response body to String, because this body does not return a String from the database
      _responseModel = ResponseModel(true, response.body['zone_id'].toString());
    } else {
      _inZone = false;
      _responseModel = ResponseModel(false, response.statusText!);
    }

    markerLoad ? _loading = false : _isLoading = false;

    update();
    return _responseModel;
  }

  //Method that searches a location text in the server, looks for available matches and send it back
  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _predictionList = [];
        response.body['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  //Method that sets the map and position to the one selected by the user in the search bar
  setLocation(
      String placeID, String address, GoogleMapController mapController) async {
    _loading = true;
    update();

    //Get the information about the location selected by the user through the placeID
    Response response = await locationRepo.setLocation(placeID);

    //convert the response to a PlacesDetailsResponse object
    PlacesDetailsResponse detail;
    detail = PlacesDetailsResponse.fromJson(response.body);

    //Set the map position to the one selected
    _pickPosition = Position(
      longitude: detail.result.geometry!.location.lng,
      latitude: detail.result.geometry!.location.lat,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
    );

    _pickPlacemark = Placemark(name: address);
    _changeAddress = false;

    //If mapController is not null
    if (mapController != null) {
      //Animate the map from it's previous location to this one
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          detail.result.geometry!.location.lat,
          detail.result.geometry!.location.lng,
        ),
        zoom: 17,
      )));
    }
    _loading = false;
    update();
  }
}
