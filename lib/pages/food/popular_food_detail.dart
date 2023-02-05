import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/controllers/popular_product_controller.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/app_column.dart';
import 'package:kariva/widgets/app_icon.dart';
import 'package:kariva/widgets/big_text.dart';
import 'package:kariva/widgets/expandable_text_widget.dart';

class PopularFoodDetail extends StatelessWidget {
  const PopularFoodDetail(
      {Key? key, required this.pageId, required this.previousPage})
      : super(key: key);
  final int pageId; //pageId is the index of the product in the List
  final String
      previousPage; //previousPage is the route name of the page we are coming from

  @override
  Widget build(BuildContext context) {
    var product =
        Get.find<PopularProductController>().popularProductList[pageId];
    //We also initialize CartController, so we can use it for this particular page
    //Every product page controller must have an instance of CartController, so we can modify cart items
    //We don't call CartController directly from our UI, we call it from our product controller (In this case PopularProductController)
    Get.find<PopularProductController>()
        .initialize(product, Get.find<CartController>());

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            //background image
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: Dimensions.popularFoodImageHeight,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(AppConstants.BASE_URL +
                            AppConstants.UPLOAD_URL +
                            product.img!))),
              ),
            ),
            //icon widgets
            Positioned(
              top: Dimensions.d45,
              left: Dimensions.d20,
              right: Dimensions.d20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => previousPage == RouteHelper.cartPage
                        ? Get.toNamed(RouteHelper.getCartPage())
                        : Get.toNamed(RouteHelper.getInitial()),
                    child: AppIcon(icon: Icons.arrow_back_ios),
                  ),
                  GetBuilder<PopularProductController>(builder: (controller) {
                    return GestureDetector(
                      //Only open CartPage if there are items in the cart
                      onTap: () => controller.totalItems >= 1
                          ? Get.toNamed(RouteHelper.getCartPage())
                          : null,
                      child: Stack(
                        children: [
                          AppIcon(icon: Icons.shopping_cart_outlined),
                          //Only show this widget if there are items in the cart
                          controller.totalItems >= 1
                              ? Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    height: Dimensions.d20,
                                    width: Dimensions.d20,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: AppColors.mainColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: BigText(
                                      text: controller.totalItems.toString(),
                                      size: Dimensions.d12,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
            //introduction widget
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Dimensions.popularFoodImageHeight - Dimensions.d20,
              child: Container(
                padding: EdgeInsets.only(
                    left: Dimensions.d20,
                    right: Dimensions.d20,
                    top: Dimensions.d20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.d20),
                    topRight: Radius.circular(Dimensions.d20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppColumn(
                      text: product.name!,
                      textSize: Dimensions.d26,
                    ),
                    SizedBox(height: Dimensions.d20),
                    const BigText(text: 'Introduce'),
                    SizedBox(height: Dimensions.d20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ExpandableTextWidget(
                          text: product.description!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            GetBuilder<PopularProductController>(builder: (controller) {
          return Container(
            height: Dimensions.bottomBarHeight,
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.d20, vertical: Dimensions.d30),
            decoration: BoxDecoration(
              color: AppColors.buttonBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.d40),
                topRight: Radius.circular(Dimensions.d40),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.d20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.d20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => controller.setQuantity(false),
                        child: const Icon(
                          Icons.remove,
                          color: AppColors.signColor,
                        ),
                      ),
                      SizedBox(width: Dimensions.d10),
                      BigText(
                          text: controller.totalQuantityOfTheItem.toString()),
                      SizedBox(width: Dimensions.d10),
                      InkWell(
                        onTap: () => controller.setQuantity(true),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.signColor,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.addItem(product);
                  },
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.d20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.d20),
                      color: AppColors.mainColor,
                    ),
                    child: BigText(
                        text: '\$ ${product.price!} | Add to cart',
                        color: Colors.white),
                  ),
                )
              ],
            ),
          );
        }));
  }
}
