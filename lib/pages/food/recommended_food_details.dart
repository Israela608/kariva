import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/controllers/popular_product_controller.dart';
import 'package:kariva/controllers/recommended_product_controller.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/app_icon.dart';
import 'package:kariva/widgets/big_text.dart';
import 'package:kariva/widgets/expandable_text_widget.dart';

class RecommendedFoodDetails extends StatelessWidget {
  const RecommendedFoodDetails(
      {Key? key, required this.pageId, required this.previousPage})
      : super(key: key);
  final int pageId;
  final String previousPage;

  @override
  Widget build(BuildContext context) {
    var product =
        Get.find<RecommendedProductController>().recommendedProductList[pageId];
    print('Page ID is   ' + pageId.toString());
    print('Product name is    ' + product.name.toString());

    //We initialize CartController in PopularProductController since we will be reusing
    //the methods in PopularProductController for our Recommended Foods, instead of
    //re-writing the same methods in RecommendedFoodController.
    //All the selected foods will be stored in the same cart (whether popular or recommended)
    Get.find<PopularProductController>()
        .initialize(product, Get.find<CartController>());

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false, //Remove the automatic back button
            pinned: true,
            toolbarHeight: 70,
            expandedHeight: 300,
            backgroundColor: AppColors.yellowColor,
            //The flexible part of the AppBar. We put the background here
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                AppConstants.BASE_URL + AppConstants.UPLOAD_URL + product.img!,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            //The top widget of the AppBar
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => previousPage == RouteHelper.cartPage
                      ? Get.toNamed(RouteHelper.getCartPage())
                      : Get.toNamed(RouteHelper.getInitial()),
                  child: AppIcon(icon: Icons.clear),
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
            //The bottom widget of the AppBar
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.d20),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.d20),
                      topRight: Radius.circular(Dimensions.d20),
                    )),
                child: Center(
                  child: BigText(
                    text: product.name!,
                    size: Dimensions.d26,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.d20),
                  child: ExpandableTextWidget(
                    text: product.description!,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      //We're going to use some of the reusable methods in PopularProductController,
      // instead of re-writing them again in RecommendedProductController, since we're
      //going to add all the selected foods into the same cart
      bottomNavigationBar: GetBuilder<PopularProductController>(
        builder: ((controller) {
          return Column(
            //Since using column in bottomNavigationBar gives error, we use this parameter to prevent errors by fitting the column to it's minimum size
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.d50, vertical: Dimensions.d10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => controller.setQuantity(false),
                      child: AppIcon(
                        icon: Icons.remove,
                        iconColor: Colors.white,
                        iconSize: Dimensions.d24,
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),
                    BigText(
                      text:
                          '\$ ${product.price!}  X  ${controller.totalQuantityOfTheItem}',
                      color: AppColors.mainBlackColor,
                      size: Dimensions.d26,
                    ),
                    InkWell(
                      onTap: () => controller.setQuantity(true),
                      child: AppIcon(
                        icon: Icons.add,
                        iconColor: Colors.white,
                        iconSize: Dimensions.d24,
                        backgroundColor: AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                      child: const Icon(
                        Icons.favorite,
                        color: AppColors.mainColor,
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.addItem(product),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.d20),
                          color: AppColors.mainColor,
                        ),
                        child: BigText(
                            text:
                                '\$ ${controller.totalItemPrice(product)} | Add to cart',
                            color: Colors.white),
                        padding: EdgeInsets.all(Dimensions.d20),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
