import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kariva/base/custom_button.dart';
import 'package:kariva/controllers/location_controller.dart';
import 'package:kariva/pages/address/widgets/search_location_dialogue_page.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';

class PickAddressMap extends StatefulWidget {
  const PickAddressMap({
    Key? key,
    required this.fromSignup,
    required this.fromAddress,
    this.googleMapController,
  }) : super(key: key);

  final bool fromSignup;
  final bool fromAddress;
  final GoogleMapController? googleMapController;

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();

    //If addressList is empty, i.e if there is no address stored in the server yet
    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = const LatLng(45.51563, -122.677433);
      _cameraPosition = CameraPosition(
        target: _initialPosition,
        zoom: 17,
      );
    } else {
      //If there is a location address or a list of addresses from the database
      if (Get.find<LocationController>().addressList.isNotEmpty) {
        /*//If there's no address stored in our local storage
      if (Get.find<LocationController>().getUserAddressFromLocalStorage() ==
          '') {
        //Save the last (latest) address from the database to our local storage
        Get.find<LocationController>()
            .saveUserAddress(Get.find<LocationController>().addressList.last);
      }*/

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
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                children: [
                  //Map
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 17,
                    ),
                    zoomControlsEnabled: false,
                    // compassEnabled: false,
                    // indoorViewEnabled: true,
                    // mapToolbarEnabled: false,
                    // //Activate Enable location dialog if location is not enabled
                    // myLocationEnabled: true,
                    //When camera is moved, update the _cameraPosition
                    onCameraMove: ((CameraPosition position) =>
                        _cameraPosition = position),
                    onCameraIdle: () {
                      //Since we are not calling this method from the addAddressPage, we set the argument to false
                      locationController.updatePosition(_cameraPosition, false);
                    },
                    // //When map is created, set the controller
                    onMapCreated: (GoogleMapController mapController) {
                      _mapController = mapController;
                      //if(!widget.fromAddress){}
                    },
                  ),
                  //Pick marker
                  Center(
                      child: !locationController.loading
                          ? Image.asset(
                              'assets/image/pick_marker.png',
                              height: Dimensions.d50,
                              width: Dimensions.d50,
                            )
                          : const CircularProgressIndicator()),
                  //Address bar
                  Positioned(
                    top: Dimensions.d45,
                    left: Dimensions.d20,
                    right: Dimensions.d20,
                    child: InkWell(
                      onTap: () => Get.dialog(
                          LocationDialogue(mapController: _mapController)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimensions.d10),
                        height: Dimensions.d50,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(Dimensions.d10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: Dimensions.d25,
                              color: AppColors.yellowColor,
                            ),
                            Expanded(
                              child: Text(
                                '  ${locationController.pickPlacemark.name ?? ''}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.d16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: Dimensions.d10),
                            Icon(
                              Icons.search,
                              size: Dimensions.d25,
                              color: AppColors.yellowColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Button
                  Positioned(
                    bottom: Dimensions.d80,
                    left: Dimensions.d20,
                    right: Dimensions.d20,
                    //Show the button when isLoading is false
                    child: !locationController.isLoading
                        ? CustomButton(
                            //If you're in the zone or area where the food delivery service is available
                            buttonText: locationController.inZone
                                //If you opened this page from the addAddressPage
                                ? widget.fromAddress
                                    ? 'Pick Address'
                                    : 'Pick Location'
                                //If you are not in the Zone of service
                                : 'Service is not available in your area',
                            //If the data is still loading or the button is disabled, then onPressed should be null
                            onPressed: (locationController.loading ||
                                    locationController.buttonDisabled)
                                ? null
                                : () {
                                    //If the information is not null
                                    if (locationController
                                                .pickPosition!.latitude !=
                                            0 &&
                                        locationController.pickPlacemark.name !=
                                            null) {
                                      //If we opened this page from our addAddressPage
                                      if (widget.fromAddress) {
                                        //If the map has been created
                                        if (widget.googleMapController !=
                                            null) {
                                          print('Now you can click on this');
                                          //Save the new camera position to the controller
                                          /* widget.googleMapController!
                                              .moveCamera(CameraUpdate
                                                  .newCameraPosition(
                                                      CameraPosition(
                                                          target: LatLng(
                                            locationController
                                                .pickPosition!.latitude,
                                            locationController
                                                .pickPosition!.longitude,
                                          ))));*/
                                          //Set the address values across all the necessary pages
                                          locationController
                                              .setAddAddressData();
                                        }
                                        //Go back
                                        //Get.back();

                                        Get.toNamed(
                                            RouteHelper.getAddressPage());
                                      }
                                    }
                                  },
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
