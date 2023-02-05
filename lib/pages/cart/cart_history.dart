import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kariva/base/no_data_page.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/models/cart_model.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/app_icon.dart';
import 'package:kariva/widgets/big_text.dart';
import 'package:kariva/widgets/small_text.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //The latest item is at the top
    var getCartHistoryList =
        Get.find<CartController>().getCartHistoryList().reversed.toList();

    //This map groups all the items in getCartHistoryList according to their time.
    //e.g {2022-09-01 23:22:27.022823: 3, 2022-09-02 23:22:27.022823: 1, 2022-09-03 23:22:27.022823: 4}
    //Time is the id. The number of items with this time is the value
    Map<String, int> cartItemsPerOrder = Map();
    //Loop through the entire list
    for (int i = 0; i < getCartHistoryList.length; i++) {
      //If this map already has a value with this particular time
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        //Increase the number of occurence by 1
        cartItemsPerOrder.update(
            getCartHistoryList[i].time!, (value) => ++value);
      } else {
        //If the item does not exist in the map
        //Then return 1 as the value, since this is the first value
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    //Converts the map above into a list of number of items per order
    List<int> cartItemsPerOrderToList() {
      //We convert the cartItemPerOrder map into a List keeping only the values
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    //Converts the map above into a list of time of each order
    List<String> cartOrderTimeToList() {
      //We convert the cartItemPerOrder map into a List keeping only the keys
      return cartItemsPerOrder.entries.map((e) => e.key).toList();
    }

    //Since we need a function to return a lists, we convert the list above into functions
    //Function that returns the number of items in each order, e.g [3, 1, 4]
    List<int> itemsPerOrder = cartItemsPerOrderToList();

    //Function that returns the number of items in each order, e.g [2022-09-01 23:22:27.022823, 2022-09-02 23:22:27.022823, 2022-09-03 23:22:27.022823]
    List<String> orderTime = cartOrderTimeToList();

    //This counter increases consecutively. It is use to locate an item in the general list (getCartHistoryList)
    var listCounter = 0;

    /*for (int i = 0; i < cartItemsPerOrder.length; i++) {
      for (int j = 0; j < itemsPerOrder[i]; j++) {
        print('Inner loop y index   ' + j.toString());
        print('My order is   ' + getCartHistoryList[listCounter++].toString());
      }
    }*/

    Widget timeWidget() {
      var outputDate = DateTime.now().toString();

      //To prevent errors
      if (listCounter < getCartHistoryList.length) {
        //We parse the input date or time according to it's original format
        DateTime parseDate = DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse(getCartHistoryList[listCounter].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        //We create a format for our output date
        var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
        //We format the input date to our preferred output format
        outputDate = outputFormat.format(inputDate);
      }

      return BigText(text: outputDate);
    }

    return Scaffold(
      body: Column(
        children: [
          //header or app bar
          Container(
            height: Dimensions.d100,
            width: double.maxFinite,
            color: AppColors.mainColor,
            padding: EdgeInsets.only(top: Dimensions.d45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const BigText(
                  text: 'Cart History',
                  color: Colors.white,
                ),
                AppIcon(
                  icon: Icons.shopping_cart_outlined,
                  iconColor: AppColors.mainColor,
                  backgroundColor: AppColors.yellowColor,
                ),
              ],
            ),
          ),
          //body
          GetBuilder<CartController>(builder: (cartController) {
            return cartController.getCartHistoryList().isNotEmpty
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: Dimensions.d20,
                        left: Dimensions.d20,
                        right: Dimensions.d20,
                      ),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          children: [
                            //The number of orders. This is the vertical list
                            for (int i = 0; i < itemsPerOrder.length; i++)
                              Container(
                                height: Dimensions.d120,
                                margin: EdgeInsets.only(bottom: Dimensions.d20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    timeWidget(),
                                    SizedBox(height: Dimensions.d10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Wrap(
                                          direction: Axis.horizontal,
                                          //The number of items per order. The horizontal list
                                          children: List.generate(
                                              itemsPerOrder[i], (index) {
                                            if (listCounter <
                                                getCartHistoryList.length) {
                                              listCounter++;
                                            }
                                            /* print('LIST COUNTER    ' +
                                      listCounter.toString());*/
                                            //Only display 3 items for each order. If more than 3, replace with empty containers
                                            return index <= 2
                                                ? Container(
                                                    height: Dimensions.d80,
                                                    width: Dimensions.d80,
                                                    margin: EdgeInsets.only(
                                                        right: Dimensions.d5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                Dimensions.d15 /
                                                                    2),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            /*image: NetworkImage(
                                                        AppConstants.BASE_URL +
                                                            AppConstants
                                                                .UPLOAD_URL +
                                                            getCartHistoryList[
                                                                    listCounter++]
                                                                .img!))),*/
                                                            image: NetworkImage(AppConstants
                                                                    .BASE_URL +
                                                                AppConstants
                                                                    .UPLOAD_URL +
                                                                getCartHistoryList[
                                                                        listCounter -
                                                                            1]
                                                                    .img!))),
                                                  )
                                                : Container();
                                          }),
                                        ),
                                        Container(
                                          height: Dimensions.d80,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const SmallText(
                                                text: 'Total',
                                                color: AppColors.titleColor,
                                              ),
                                              //IIFE - Immediately invoked function expression
                                              () {
                                                int numberOfItems =
                                                    itemsPerOrder[i];
                                                String s = numberOfItems == 1
                                                    ? ''
                                                    : 's';
                                                return BigText(
                                                  text:
                                                      numberOfItems.toString() +
                                                          ' item' +
                                                          s,
                                                  color: AppColors.titleColor,
                                                );
                                              }(),
                                              GestureDetector(
                                                onTap: () {
                                                  /* print('ORDER TIME    ' +
                                              orderTime[i].toString());*/
                                                  //This map will store the id and product of all the items in the order that was pressed
                                                  Map<int, CartModel>
                                                      moreOrder = {};
                                                  //Loop through the general List
                                                  for (int j = 0;
                                                      j <
                                                          getCartHistoryList
                                                              .length;
                                                      j++) {
                                                    //If the time of the item in the general list is equal to the time of the order we pressed
                                                    if (getCartHistoryList[j]
                                                            .time ==
                                                        orderTime[i]) {
                                                      //You can use jSonEncode to print anything inside an object
                                                      /* print('Product info is   ' +
                                                  jsonEncode(
                                                      getCartHistoryList[j]));*/

                                                      /* moreOrder.putIfAbsent(
                                                  getCartHistoryList[j].id!,
                                                  () => getCartHistoryList[j]);
*/
                                                      moreOrder.putIfAbsent(
                                                          getCartHistoryList[j]
                                                              .id!,
                                                          () => CartModel.fromJson(
                                                              jsonDecode(jsonEncode(
                                                                  getCartHistoryList[
                                                                      j]))));
                                                    }
                                                  }

                                                  //Set the items map in CartController to our map of items of this order. i.e populate our cart page with the items of this order
                                                  cartController.setItems =
                                                      moreOrder;
                                                  //Add the items to cart list SharedPreferences storage and update the ui
                                                  cartController
                                                      .addToCartList();
                                                  Get.toNamed(RouteHelper
                                                      .getCartPage());
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: Dimensions.d10,
                                                    vertical: Dimensions.d5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions.d5),
                                                    border: Border.all(
                                                      width: 1,
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                                  ),
                                                  child: const SmallText(
                                                    text: 'one more',
                                                    color: AppColors.mainColor,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                : Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: const Center(
                        child: NoDataPage(
                          text: "You didn't buy anything so far !",
                          imgPath: 'assets/image/empty_box.png',
                        ),
                      ),
                    ),
                  );
          }),
        ],
      ),
    );
  }
}
