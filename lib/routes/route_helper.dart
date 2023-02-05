import 'package:get/get.dart';
import 'package:kariva/models/order_model.dart';
import 'package:kariva/pages/address/add_address_page.dart';
import 'package:kariva/pages/address/pick_address_map.dart';
import 'package:kariva/pages/auth/sign_in_page.dart';
import 'package:kariva/pages/cart/cart_page.dart';
import 'package:kariva/pages/food/popular_food_detail.dart';
import 'package:kariva/pages/food/recommended_food_details.dart';
import 'package:kariva/pages/home/home_page.dart';
import 'package:kariva/pages/payment/order_success_page.dart';
import 'package:kariva/pages/payment/payment_page.dart';
import 'package:kariva/pages/splash/splash_page.dart';

class RouteHelper {
  static const String splashPage = '/splash_page';
  static const String initial = '/';
  static const String popularFood = '/popular_food';
  static const String recommendedFood = '/recommended_food';
  static const String cartPage = '/cart_page';
  static const String signIn = '/sign_in';
  static const String addAddress = '/add_address';
  static const String pickAddressMap = '/pick_address';
  static const String payment = '/payment';
  static const String orderSuccess = '/order_successful';

  static String getSplashPage() => '$splashPage';
  static String getInitial() => '$initial';
  //You can use ?variable= to set a parameter or variable in a String. For subsequent variables, you use &variable=
  //Here pageId is the index of the product in the popularProductList that will use to populate the popularFood page
  //previousPage is the route name of the page we are coming from
  static String getPopularFood(int pageId, String previousPage) =>
      '$popularFood?pageId=$pageId&previousPage=$previousPage';
  static String getRecommendedFood(int pageId, String previousPage) =>
      '$recommendedFood?pageId=$pageId&previousPage=$previousPage';
  static String getCartPage() => '$cartPage';
  static String getSignInPage() => '$signIn';
  static String getAddressPage() => '$addAddress';
  static String getPickAddressPage() => '$pickAddressMap';
  static String getPaymentPage(String id, int userID) =>
      '$payment?id=$id&userID=$userID';
  static String getOrderSuccessPage(String orderID, String status) =>
      '$orderSuccess?id=$orderID&status=$status';

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: () => const SplashPage()),
    GetPage(
      name: initial,
      page: () => const HomePage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: signIn,
      page: () => const SignInPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: popularFood,
      page: () {
        //We use Get.parameters[] to catch the String parameter, and then we assign it to an actual variable
        var pageId = Get.parameters['pageId'];
        var previousPage = Get.parameters['previousPage'];
        return PopularFoodDetail(
          pageId: int.parse(pageId!),
          previousPage: previousPage!,
        );
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: recommendedFood,
      page: () {
        var pageId = Get.parameters['pageId'];
        var previousPage = Get.parameters['previousPage'];
        return RecommendedFoodDetails(
          pageId: int.parse(pageId!),
          previousPage: previousPage!,
        );
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cartPage,
      page: () => const CartPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(name: addAddress, page: () => const AddAddressPage()),
    GetPage(
      name: pickAddressMap,
      page: () {
        //Normal way of getting all the arguments while moving to a route using getX
        PickAddressMap _pickAddress = Get.arguments;
        //Go to the page
        return _pickAddress;
      },
    ),
    GetPage(
      name: payment,
      page: () {
        return PaymentPage(
            orderModel: OrderModel(
          id: int.parse(Get.parameters['id']!),
          userId: int.parse(Get.parameters['userID']!),
        ));
      },
    ),
    GetPage(
        name: orderSuccess,
        page: () => OrderSuccessPage(
              orderID: Get.parameters['id']!,
              //If the status is 'success' then the status integer sent to this page is 1, else 0
              status: Get.parameters['status'].toString().contains('success')
                  ? 1
                  : 0,
            )),
  ];
}
