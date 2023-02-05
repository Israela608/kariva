import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/base/custom_app_bar.dart';
import 'package:kariva/base/custom_loader.dart';
import 'package:kariva/controllers/auth_controller.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/controllers/location_controller.dart';
import 'package:kariva/controllers/user_controller.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/account_widget.dart';
import 'package:kariva/widgets/app_icon.dart';
import 'package:kariva/widgets/big_text.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    //If the user is logged in
    if (_userLoggedIn) {
      //Get the user information from the server.
      Get.find<UserController>().getUserInfo();
      print('User has logged in');
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: GetBuilder<UserController>(
        builder: (userController) {
          //If the user is logged in
          return _userLoggedIn
              //Show the User profile page
              ? (userController.isLoaded
                  ? Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: Dimensions.d20),
                      child: Column(
                        children: [
                          //profile icon
                          AppIcon(
                            icon: Icons.person,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.d75,
                            size: Dimensions.d150,
                          ),
                          SizedBox(height: Dimensions.d30),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  //name
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.person,
                                      backgroundColor: AppColors.mainColor,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.d25,
                                      size: Dimensions.d50,
                                    ),
                                    bigText: BigText(
                                        text: userController.userModel.name!),
                                  ),
                                  SizedBox(height: Dimensions.d20),
                                  //phone
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.phone,
                                      backgroundColor: AppColors.yellowColor,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.d25,
                                      size: Dimensions.d50,
                                    ),
                                    bigText: BigText(
                                        text: userController.userModel.phone!),
                                  ),
                                  SizedBox(height: Dimensions.d20),
                                  //email
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.email,
                                      backgroundColor: AppColors.yellowColor,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.d25,
                                      size: Dimensions.d50,
                                    ),
                                    bigText: BigText(
                                        text: userController.userModel.email!),
                                  ),
                                  SizedBox(height: Dimensions.d20),
                                  //address
                                  GetBuilder<LocationController>(
                                      builder: (locationController) {
                                    //If the user is Logged in, but the address list is empty
                                    if (_userLoggedIn &&
                                        locationController
                                            .addressList.isEmpty) {
                                      return AccountWidget(
                                        onPressed: () {
                                          //Go to the AddAddressPage
                                          Get.offNamed(
                                              RouteHelper.getAddressPage());
                                        },
                                        appIcon: AppIcon(
                                          icon: Icons.location_on,
                                          backgroundColor:
                                              AppColors.yellowColor,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.d25,
                                          size: Dimensions.d50,
                                        ),
                                        bigText: const BigText(
                                            text: 'Fill in your address'),
                                      );
                                    } else {
                                      //If there is an address or list of addresses already
                                      return AccountWidget(
                                        onPressed: () {
                                          /////////////////////////////////////////
                                          //Go to the AddAddressPage
                                          Get.offNamed(
                                              RouteHelper.getAddressPage());
                                        },
                                        appIcon: AppIcon(
                                          icon: Icons.location_on,
                                          backgroundColor:
                                              AppColors.yellowColor,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.d25,
                                          size: Dimensions.d50,
                                        ),
                                        bigText:
                                            const BigText(text: 'Your address'),
                                      );
                                    }
                                  }),
                                  SizedBox(height: Dimensions.d20),
                                  //message
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.message_outlined,
                                      backgroundColor: Colors.redAccent,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.d25,
                                      size: Dimensions.d50,
                                    ),
                                    bigText: const BigText(text: 'Messages'),
                                  ),
                                  SizedBox(height: Dimensions.d20),
                                  //logout
                                  AccountWidget(
                                    onPressed: () {
                                      //If user is logged in
                                      if (Get.find<AuthController>()
                                          .userLoggedIn()) {
                                        //Clear Login data
                                        Get.find<AuthController>()
                                            .clearSharedData();
                                        //Clear the cart list
                                        Get.find<CartController>().clear();
                                        //clear the stored cart list and stored cart history list
                                        Get.find<CartController>()
                                            .clearCartHistory();
                                        //Clear the address list
                                        Get.find<LocationController>()
                                            .clearAddressList();
                                        //Go to home page
                                        Get.offNamed(
                                            RouteHelper.getSignInPage());
                                      }
                                    },
                                    appIcon: AppIcon(
                                      icon: Icons.logout,
                                      backgroundColor: Colors.redAccent,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.d25,
                                      size: Dimensions.d50,
                                    ),
                                    bigText: const BigText(text: 'Logout'),
                                  ),
                                  SizedBox(height: Dimensions.d50),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const CustomLoader())
              //else show this
              : Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: Dimensions.d160,
                          margin:
                              EdgeInsets.symmetric(horizontal: Dimensions.d20),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.d20),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/image/signintocontinue.png'),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.getSignInPage());
                          },
                          child: Container(
                            width: double.maxFinite,
                            height: Dimensions.d100,
                            margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.d20),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.d20),
                            ),
                            child: Center(
                              child: BigText(
                                text: 'Sign in',
                                color: Colors.white,
                                size: Dimensions.d26,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
