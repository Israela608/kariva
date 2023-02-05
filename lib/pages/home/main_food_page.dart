import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/controllers/popular_product_controller.dart';
import 'package:kariva/controllers/recommended_product_controller.dart';
import 'package:kariva/pages/home/food_page_body.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/big_text.dart';
import 'package:kariva/widgets/small_text.dart';

class MainFoodPage extends StatelessWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  //Method that load our resources from the database
  Future<void> _loadResources() async {
    //Initialize the controller. You can use Get.find<> to locate an item saved in GetX internally
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
    //SharedPreferences
    Get.find<CartController>().getCartData();
  }

  @override
  Widget build(BuildContext context) {
    //print('SCREEN SIZE' + MediaQuery.of(context).size.toString());
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadResources,

        //Column default alignment is top. Elements in a column are aligned at the top of the containing widget
        //Row default alignment is at the left center. Elements in a row occupy the center left of the containing widget
        child: Column(
          children: [
            Container(
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.d45, bottom: Dimensions.d15),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.d20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const BigText(
                          text: 'Bangladesh',
                          color: AppColors.mainColor,
                        ),
                        Row(
                          children: const [
                            SmallText(
                              text: 'Narsingdi',
                              color: Colors.black54,
                            ),
                            Icon(Icons.arrow_drop_down_rounded)
                          ],
                        )
                      ],
                    ),
                    Container(
                      width: Dimensions.d45,
                      height: Dimensions.d45,
                      child: const Center(
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.d15),
                        color: AppColors.mainColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Expanded(child: SingleChildScrollView(child: FoodPageBody())),
          ],
        ),
      ),
    );
  }
}
