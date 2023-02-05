import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/base/common_text_button.dart';
import 'package:kariva/base/no_data_page.dart';
import 'package:kariva/base/show_custom_snackbar.dart';
import 'package:kariva/controllers/auth_controller.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/controllers/location_controller.dart';
import 'package:kariva/controllers/order_controller.dart';
import 'package:kariva/controllers/popular_product_controller.dart';
import 'package:kariva/controllers/recommended_product_controller.dart';
import 'package:kariva/controllers/user_controller.dart';
import 'package:kariva/models/place_order_model.dart';
import 'package:kariva/pages/order/delivery_options.dart';
import 'package:kariva/pages/order/payment_option_button.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/utils/styles.dart';
import 'package:kariva/widgets/app_icon.dart';
import 'package:kariva/widgets/app_text_field.dart';
import 'package:kariva/widgets/big_text.dart';
import 'package:kariva/widgets/small_text.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();

    return Scaffold(
        body: Stack(
          children: [
            //header
            Positioned(
              top: Dimensions.d60,
              left: Dimensions.d20,
              right: Dimensions.d20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIcon(
                    icon: Icons.arrow_back_ios,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.d24,
                  ),
                  SizedBox(width: Dimensions.d100),
                  GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.getInitial()),
                    child: AppIcon(
                      icon: Icons.home_outlined,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.d24,
                    ),
                  ),
                  AppIcon(
                    icon: Icons.shopping_cart,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.d24,
                  ),
                ],
              ),
            ),
            //body
            GetBuilder<CartController>(builder: (catController) {
              return catController.getItems.isNotEmpty
                  ? Positioned(
                      top: Dimensions.d100,
                      left: Dimensions.d20,
                      right: Dimensions.d20,
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.d15),
                        //color: Colors.red,

                        //Widget that removes the padding of it's child widget.
                        //In this case, we want the top padding of the ListView removed
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GetBuilder<CartController>(
                            builder: (cartController) {
                              var _cartList = cartController.getItems;
                              return ListView.builder(
                                itemCount: _cartList.length,
                                itemBuilder: (_, index) {
                                  return Container(
                                    height: Dimensions.d100,
                                    width: double.maxFinite,
                                    margin:
                                        EdgeInsets.only(bottom: Dimensions.d10),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            //.indexOf() takes the ProductModel value of this product from the cart and checks the popularProductList
                                            // to find out if the product is available in the list. If available, it returns the exact index of that product
                                            // in the popularProductList. We use this index to locate the page of this product.
                                            // If the product is not available, it returns -1
                                            int popularIndex = Get.find<
                                                    PopularProductController>()
                                                .popularProductList
                                                .indexOf(
                                                    _cartList[index].product!);
                                            /*print('PRODUCT INDEX:    ' +
                                      popularIndex.toString());*/

                                            //If popularIndex is not -1 (i.e the item is available in the popularProductList in PopularProductController)
                                            if (popularIndex >= 0) {
                                              //Then move to the page of the item or product
                                              Get.toNamed(
                                                  RouteHelper.getPopularFood(
                                                popularIndex,
                                                RouteHelper.cartPage,
                                              ));
                                            }
                                            //If it's not in popularProductList, then it has to be in recommendedProductList.
                                            else {
                                              //Check if the product is in recommendedProductList and assign the index to recommendedIndex.
                                              // If not available return -1 (But it has to be available here, since it's not in popularProductList)
                                              int recommendedIndex = Get.find<
                                                      RecommendedProductController>()
                                                  .recommendedProductList
                                                  .indexOf(_cartList[index]
                                                      .product!);

                                              if (recommendedIndex >= 0) {
                                                //Then move to the page of the item
                                                Get.toNamed(RouteHelper
                                                    .getRecommendedFood(
                                                        recommendedIndex,
                                                        RouteHelper.cartPage));
                                              } else {
                                                //Since both popular and recommended product pages returned -1, then the product is from history page
                                                Get.snackbar(
                                                  'History product',
                                                  'Product review is not available for history products',
                                                  backgroundColor:
                                                      AppColors.mainColor,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: Dimensions.d100,
                                            width: Dimensions.d100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.d20),
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      AppConstants.BASE_URL +
                                                          AppConstants
                                                              .UPLOAD_URL +
                                                          _cartList[index]
                                                              .img!),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: Dimensions.d10),
                                        Expanded(
                                          child: Container(
                                            height: Dimensions.d100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                BigText(
                                                  text: cartController
                                                      .getItems[index].name!,
                                                  color: Colors.black54,
                                                ),
                                                const SmallText(text: 'Spicy'),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    BigText(
                                                      text: '\$ ' +
                                                          _cartList[index]
                                                              .price!
                                                              .toString(),
                                                      color: Colors.redAccent,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          Dimensions.d10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    Dimensions
                                                                        .d20),
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            //Since we are updating the item in the CartModel (through the addItem method in CartController),
                                                            // the quantity we assign here will be added to the previous quantity. Since the quantity we assigned here is -1,
                                                            // it means the quantity of this item is one less when this Widget is tapped
                                                            onTap: () =>
                                                                cartController.addItem(
                                                                    _cartList[
                                                                            index]
                                                                        .product!,
                                                                    -1),
                                                            child: const Icon(
                                                              Icons.remove,
                                                              color: AppColors
                                                                  .signColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: Dimensions
                                                                  .d10),
                                                          BigText(
                                                            text:
                                                                _cartList[index]
                                                                    .quantity
                                                                    .toString(),
                                                          ),
                                                          SizedBox(
                                                              width: Dimensions
                                                                  .d10),
                                                          InkWell(
                                                            //We update the quantity of this item by adding 1 to the quantity
                                                            onTap: () =>
                                                                cartController.addItem(
                                                                    _cartList[
                                                                            index]
                                                                        .product!,
                                                                    1),
                                                            child: const Icon(
                                                              Icons.add,
                                                              color: AppColors
                                                                  .signColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : const NoDataPage(text: 'Your cart is empty!');
            }),
          ],
        ),
        bottomNavigationBar:
            GetBuilder<OrderController>(builder: (orderController) {
          //Set the note String already saved in the memory to our note here. If there is no text, then it's set to an empty String
          _noteController.text = orderController.foodNote;
          return GetBuilder<CartController>(builder: (cartController) {
            return cartController.getItems.isNotEmpty
                ? Container(
                    height: Dimensions.bottomBarHeight + Dimensions.d50,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.d20, vertical: Dimensions.d10),
                    decoration: BoxDecoration(
                      color: AppColors.buttonBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.d40),
                        topRight: Radius.circular(Dimensions.d40),
                      ),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (_) {
                              return Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  Dimensions.d20),
                                              topRight: Radius.circular(
                                                  Dimensions.d20),
                                            )),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 520,
                                              padding: EdgeInsets.only(
                                                left: Dimensions.d20,
                                                right: Dimensions.d20,
                                                top: Dimensions.d20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const PaymentOptionButton(
                                                    icon: Icons.money,
                                                    title: 'cash on delivery',
                                                    subtitle:
                                                        'you pay after getting the delivery',
                                                    index: 0,
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions.d10),
                                                  const PaymentOptionButton(
                                                    icon: Icons.paypal_outlined,
                                                    title: 'digital payment',
                                                    subtitle:
                                                        'safer and faster way of payment',
                                                    index: 1,
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions.d30),
                                                  Text(
                                                    'Delivery options',
                                                    style: robotoMedium,
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions.d5),
                                                  DeliveryOptions(
                                                    value: 'delivery',
                                                    title: 'Home delivery',
                                                    amount: double.parse(
                                                        Get.find<
                                                                CartController>()
                                                            .totalAmount
                                                            .toString()),
                                                    isFree: false,
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions.d5),
                                                  const DeliveryOptions(
                                                    value: 'take away',
                                                    title: 'Take away',
                                                    amount: 0.0,
                                                    isFree: true,
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions.d20),
                                                  Text(
                                                    'Additional notes',
                                                    style: robotoMedium,
                                                  ),
                                                  AppTextField(
                                                    textController:
                                                        _noteController,
                                                    hintText: '',
                                                    icon: Icons.note,
                                                    maxLines: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            //When the bottomSheet is closed, save the note text to memory
                          ).whenComplete(
                            () => orderController
                                .setFoodNote(_noteController.text.trim()),
                          ),
                          child: const SizedBox(
                            width: double.maxFinite,
                            child: CommonTextButton(
                                text: 'Payment and delivery options'),
                          ),
                        ),
                        SizedBox(height: Dimensions.d10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimensions.d20),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.d20),
                                color: Colors.white,
                              ),
                              child: BigText(
                                  text: '\$ ' +
                                      cartController.totalAmount.toString()),
                            ),
                            InkWell(
                              onTap: () {
                                //If the user is logged in
                                if (Get.find<AuthController>().userLoggedIn()) {
                                  //Update the firebase token
                                  Get.find<AuthController>().updateToken();
                                  //If address list is empty
                                  if (Get.find<LocationController>()
                                      .addressList
                                      .isEmpty) {
                                    //Go to address page, so we can add an address
                                    Get.toNamed(RouteHelper.getAddressPage());
                                  } else {
                                    //Else
                                    //Go to the home page
                                    //Get.offNamed(RouteHelper.getInitial());

                                    var location =
                                        Get.find<LocationController>()
                                            .getUserAddress();
                                    var cart =
                                        Get.find<CartController>().getItems;
                                    var user =
                                        Get.find<UserController>().userModel;

                                    PlaceOrderBody placeOrder = PlaceOrderBody(
                                      cart: cart,
                                      orderAmount:
                                          cartController.totalAmount.toDouble(),
                                      distance: 10.0,
                                      scheduleAt: '',
                                      orderNote: orderController.foodNote,
                                      address: location.address,
                                      latitude: location.latitude,
                                      longitude: location.longitude,
                                      contactPersonName: user.name!,
                                      contactPersonNumber: user.phone!,
                                      orderType: orderController.deliveryType,
                                      paymentMethod:
                                          orderController.paymentIndex == 0
                                              ? 'cash_on_delivery'
                                              : 'digital payment',
                                    );
                                    /* print('Note is   ' +
                                        placeOrder.toJson()['order_note']);
                                    print('My type is   ' +
                                        placeOrder.toJson()['order_type']);
                                    print('Payment method is   ' +
                                        placeOrder.toJson()['payment_method']);
                                    return;*/

                                    Get.find<OrderController>().placeOrder(
                                      placeOrder,
                                      _callback,
                                    );
                                  }
                                  //cartController.addToHistory();
                                } else {
                                  //else you have to sign in
                                  Get.toNamed(RouteHelper.getSignInPage());
                                }
                              },
                              child: const CommonTextButton(text: 'Check out'),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(height: 0);
          });
        }));
  }
}

void _callback(bool isSuccess, String message, String orderID) {
  //print('ERRORRRRR      CALLBACK');
  if (isSuccess) {
    print('SUCCESS CART PAGE');
    //Delete all stored cart items and stored cart history items
    Get.find<CartController>().removeCartSharedPreferences();
    //Store the items to cart history list and clear the cart items from memory
    Get.find<CartController>().addToHistory();

    //If cash on delivery is selected
    if (Get.find<OrderController>().paymentIndex == 0) {
      //Go directly to the success page
      Get.offNamed(RouteHelper.getOrderSuccessPage(orderID, 'success'));
    } else {
      //Go to the payment page
      Get.offNamed(RouteHelper.getPaymentPage(
          orderID, Get.find<UserController>().userModel.id!));
    }
  } else {
    print('FAILURE CART PAGE');
    showCustomSnackBar(message: message);
  }
}
