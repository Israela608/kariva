import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/base/custom_loader.dart';
import 'package:kariva/controllers/order_controller.dart';
import 'package:kariva/models/order_model.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/utils/styles.dart';

class ViewOrder extends StatelessWidget {
  const ViewOrder({Key? key, required this.isCurrent}) : super(key: key);
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(
        builder: (orderController) {
          //If loading is complete
          if (!orderController.isLoading) {
            //We create a list of OrderModel
            late List<OrderModel> orderList;
            //If any of the list (currentOrderList or historyOrderList) is not empty
            if (orderController.currentOrderList.isNotEmpty ||
                orderController.historyOrderList.isNotEmpty) {
              //If isCurrent is true, then our orderList here should be currentOrderList. If false, historyOrderList
              orderList = isCurrent
                  ? orderController.currentOrderList.reversed.toList()
                  : orderController.historyOrderList.reversed.toList();
            }

            return SizedBox(
              width: Dimensions.screenWidth,
              child: Padding(
                padding: EdgeInsets.all(Dimensions.d5),
                child: ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => null,
                      child: Container(
                        margin: EdgeInsets.only(bottom: Dimensions.d10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'order ID',
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.d12,
                                  ),
                                ),
                                SizedBox(width: Dimensions.d5),
                                Text('#${orderList[index].id.toString()}'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.d10,
                                    vertical: Dimensions.d5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius:
                                        BorderRadius.circular(Dimensions.d5),
                                  ),
                                  child: Text(
                                    '${orderList[index].orderStatus}',
                                    style: robotoMedium.copyWith(
                                      fontSize: Dimensions.d12,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimensions.d5),
                                InkWell(
                                  onTap: () => null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.d10,
                                      vertical: Dimensions.d5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(Dimensions.d5),
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/tracking.png',
                                          height: Dimensions.d15,
                                          width: Dimensions.d15,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(width: Dimensions.d5),
                                        Text(
                                          'track order',
                                          style: robotoMedium.copyWith(
                                            fontSize: Dimensions.d12,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const CustomLoader();
          }
        },
      ),
    );
  }
}
