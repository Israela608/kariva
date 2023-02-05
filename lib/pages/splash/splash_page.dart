import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/auth_controller.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/controllers/location_controller.dart';
import 'package:kariva/controllers/popular_product_controller.dart';
import 'package:kariva/controllers/recommended_product_controller.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/dimensions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  //Method that load our resources from the database
  Future<void> _loadResources() async {
    //Initialize the controller. You can use Get.find<> to locate an item saved in GetX internally
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
    //SharedPreferences
    Get.find<CartController>().getCartData();
    //Initialize the list of addresses from the server
    await Get.find<LocationController>().getAddressList();
  }

  @override
  void initState() {
    super.initState();
    //Update the firebase token
    Get.find<AuthController>().updateToken();
    //We start loading our resources at the beginning of the splash screen
    _loadResources();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    Timer(const Duration(seconds: 3),
        () => Get.offNamed(RouteHelper.getInitial()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Center(
              child: Image.asset(
                'assets/image/logo part 1.png',
                width: Dimensions.splashWidth,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/image/logo part 2.png',
              width: Dimensions.splashWidth,
            ),
          ),
        ],
      ),
    );
  }
}
