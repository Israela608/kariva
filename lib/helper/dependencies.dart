//This is the init method
import 'package:get/get.dart';
import 'package:kariva/controllers/auth_controller.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/controllers/location_controller.dart';
import 'package:kariva/controllers/order_controller.dart';
import 'package:kariva/controllers/popular_product_controller.dart';
import 'package:kariva/controllers/recommended_product_controller.dart';
import 'package:kariva/controllers/user_controller.dart';
import 'package:kariva/data/api/api_client.dart';
import 'package:kariva/data/repository/auth_repo.dart';
import 'package:kariva/data/repository/cart_repo.dart';
import 'package:kariva/data/repository/location_repo.dart';
import 'package:kariva/data/repository/order_repo.dart';
import 'package:kariva/data/repository/popular_product_repo.dart';
import 'package:kariva/data/repository/recommended_product_repo.dart';
import 'package:kariva/data/repository/user_repo.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Dependency Injection
Future<void> init() async {
  //We create the SharedPreferences instance at the beginning
  final sharedPreferences = await SharedPreferences.getInstance();

  //We load the SharedPreferences instance into getX state management
  Get.lazyPut(() => sharedPreferences);

  //Load ApiClient. This will save the base url into getX internally and will be used as the baseUrl in ApiClient
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  //Load Repositories. Since the ApiClient has been loaded into getX internally, you only need Get.find() to assign it here
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(
      () => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(() => OrderRepo(apiClient: Get.find()));

  //Load Controllers
  //Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  // Get.lazyPut(
  //     () => RecommendedProductController(recommendedProductRepo: Get.find()));
  //Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.put(AuthController(authRepo: Get.find()));
  Get.put(UserController(userRepo: Get.find()));
  Get.put(PopularProductController(popularProductRepo: Get.find()));
  Get.put(RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.put(CartController(cartRepo: Get.find()));
  //Get.put(LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
}
