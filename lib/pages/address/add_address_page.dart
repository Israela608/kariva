import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kariva/base/custom_app_bar.dart';
import 'package:kariva/controllers/auth_controller.dart';
import 'package:kariva/controllers/location_controller.dart';
import 'package:kariva/controllers/user_controller.dart';
import 'package:kariva/models/address_model.dart';
import 'package:kariva/pages/address/pick_address_map.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/app_text_field.dart';
import 'package:kariva/widgets/big_text.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  late bool _isLogged;
  //The initial position of the user
  late LatLng _initialPosition = const LatLng(45.51563, -122.677433);
  //The position of the map camera or map view
  CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(45.51563, -122.677433),
    zoom: 17,
  );

  @override
  void initState() {
    super.initState();
    //print('MEEEEEEE');

    _isLogged = Get.find<AuthController>().userLoggedIn();

    //If the user is logged in
    if (_isLogged) {
      Get.find<UserController>().getUserInfo();
    }

    /*Get.find<LocationController>().addressList.forEach((address) {
      print('AddressDb   ' + address.address);
    });*/

    //If there is a location address or a list of addresses from the database
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      //If there's no address stored in our local storage
      if (Get.find<LocationController>().getUserAddressFromLocalStorage() ==
          '') {
        //Save the last (latest) address from the database to our local storage
        Get.find<LocationController>()
            .saveUserAddress(Get.find<LocationController>().addressList.last);
      }

      //We initialize the address to prevent errors
      Get.find<LocationController>().getUserAddress();
      //Initialize the user's initial position
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress['latitude']),
        double.parse(Get.find<LocationController>().getAddress['longitude']),
      );
      //Initialize the map camera position
      _cameraPosition = CameraPosition(
        target: _initialPosition,
        zoom: 17,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Address'),
      body: GetBuilder<UserController>(
        builder: (userController) {
          //If the contactPersonName text is empty
          if (_contactPersonName.text.isEmpty) {
            //Fill the contact person infos
            _contactPersonName.text = userController.userModel.name ?? '';
            _contactPersonNumber.text = userController.userModel.phone ?? '';

            //If the addressList from the server is not empty
            if (Get.find<LocationController>().addressList.isNotEmpty) {
              //Then set the address text to the saved address
              _addressController.text =
                  Get.find<LocationController>().getUserAddress().address;
            }

            /* //If the addressList from the server is not empty
            if (Get.find<LocationController>()
                    .getUserAddressFromLocalStorage() !=
                '') {
              //Then set the address text to the saved address
              _addressController.text =
                  Get.find<LocationController>().getUserAddress().address;
            }*/
            //If we are coming from PickAddressMap page, meaning, pickPosition is not null
          }
          return GetBuilder<LocationController>(
            builder: (locationController) {
              //Set the Address text
              _addressController.text =
                  '${locationController.placemark.name ?? ''}'
                  '${locationController.placemark.locality ?? ''}'
                  '${locationController.placemark.postalCode ?? ''}'
                  '${locationController.placemark.country ?? ''}';

              ////////////////////////////////////////////////////////////////////
              //If the addressList from the server is not empty
              /* if (Get.find<LocationController>()
                      .getUserAddressFromLocalStorage() !=
                  '') {
                //Then set the address text to the saved address
                _addressController.text =
                    Get.find<LocationController>().getUserAddress().address;
              }*/

              print('Address in my view is   ' + _addressController.text);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Map view
                    Container(
                      height: Dimensions.d140,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: Dimensions.d5,
                          right: Dimensions.d5,
                          top: Dimensions.d5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.d5),
                          border: Border.all(
                            width: Dimensions.d2,
                            color: AppColors.mainColor,
                          )),
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: _initialPosition, zoom: 17),
                            //We don't want tto zoom in
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: false,
                            //Activate Enable location dialog if location is not enabled
                            myLocationEnabled: true,
                            onCameraIdle: () {
                              locationController.updatePosition(
                                  _cameraPosition, true);
                            },
                            //When camera is moved, update the _cameraPosition
                            onCameraMove: ((position) =>
                                _cameraPosition = position),
                            //When map is created, set the controller
                            onMapCreated: (GoogleMapController controller) {
                              locationController.setMapController(controller);
                            },
                            onTap: (latLng) {
                              Get.toNamed(RouteHelper.getPickAddressPage(),
                                  arguments: PickAddressMap(
                                    fromSignup: false,
                                    fromAddress: true,
                                    googleMapController:
                                        locationController.mapController,
                                  ));
                            },
                          )
                        ],
                      ),
                    ),
                    //Address type
                    Padding(
                      padding: EdgeInsets.only(
                          left: Dimensions.d20, top: Dimensions.d20),
                      child: SizedBox(
                        height: Dimensions.d50,
                        child: ListView.builder(
                            itemCount:
                                locationController.addressTypeList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  locationController.setAddressTypeIndex(index);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.d20,
                                    vertical: Dimensions.d10,
                                  ),
                                  margin:
                                      EdgeInsets.only(right: Dimensions.d10),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Dimensions.d5),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[200]!,
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                        )
                                      ]),
                                  child: Row(
                                    children: [
                                      Icon(
                                        //Display the icons according to it's index respectively
                                        index == 0
                                            ? Icons.home_filled
                                            : index == 1
                                                ? Icons.work
                                                : Icons.location_on,
                                        //When an index is selected, highlight the icon of that index
                                        color: locationController
                                                    .addressTypeIndex ==
                                                index
                                            ? AppColors.mainColor
                                            : Theme.of(context).disabledColor,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    SizedBox(height: Dimensions.d20),
                    //Delivery address
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.d20),
                      child: const BigText(text: 'Delivery address'),
                    ),
                    SizedBox(height: Dimensions.d10),
                    AppTextField(
                      textController: _addressController,
                      hintText: 'Your address',
                      icon: Icons.map,
                    ),
                    SizedBox(height: Dimensions.d20),
                    //Contact name
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.d20),
                      child: const BigText(text: 'Contact name'),
                    ),
                    SizedBox(height: Dimensions.d10),
                    AppTextField(
                      textController: _contactPersonName,
                      hintText: 'Your name',
                      icon: Icons.person,
                    ),
                    SizedBox(height: Dimensions.d20),
                    //Your number
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.d20),
                      child: const BigText(text: 'Your number'),
                    ),
                    SizedBox(height: Dimensions.d10),
                    AppTextField(
                      textController: _contactPersonNumber,
                      hintText: 'Your number',
                      icon: Icons.phone,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: GetBuilder<LocationController>(
        builder: ((locationController) {
          return Container(
            height: Dimensions.d160,
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.d20, vertical: Dimensions.d30),
            decoration: BoxDecoration(
              color: AppColors.buttonBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.d40),
                topRight: Radius.circular(Dimensions.d40),
              ),
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  //Create an object of AddressModel and fill the information
                  AddressModel _addressModel = AddressModel(
                    //The address type ('home', 'office', 'others') that was selected
                    addressType: locationController
                        .addressTypeList[locationController.addressTypeIndex],
                    contactPersonName: _contactPersonName.text,
                    contactPersonNumber: _contactPersonNumber.text,
                    address: _addressController.text,
                    latitude: locationController.position.latitude.toString(),
                    longitude: locationController.position.longitude.toString(),
                  );

                  locationController.addAddress(_addressModel).then((response) {
                    if (response.isSuccess) {
                      //Got to the home page
                      Get.toNamed(RouteHelper.getInitial());
                      Get.snackbar('Address', 'Added Successfully');
                    } else {
                      Get.snackbar('Address', "Couldn't save address");
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.d20),
                    color: AppColors.mainColor,
                  ),
                  child: BigText(
                    text: 'Save address',
                    color: Colors.white,
                    size: Dimensions.d26,
                  ),
                  padding: EdgeInsets.all(Dimensions.d20),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
