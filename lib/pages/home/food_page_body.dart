import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/popular_product_controller.dart';
import 'package:kariva/controllers/recommended_product_controller.dart';
import 'package:kariva/models/products_model.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/app_column.dart';
import 'package:kariva/widgets/big_text.dart';
import 'package:kariva/widgets/icon_and_text_widget.dart';
import 'package:kariva/widgets/small_text.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  _FoodPageBodyState createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  final PageController _pageController = PageController(
      viewportFraction:
          0.85); //Occupy 0.85 of the visible portion of the screen

  double _currPageValue = 0.0;
  final double _scaleFactor = 0.8;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currPageValue = _pageController.page!;
        //debugPrint('Current page value is ' + _currPageValue.toString());
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Slider section for Popular food
        GetBuilder<PopularProductController>(builder: (popularProducts) {
          return popularProducts.isLoaded
              ? SizedBox(
                  height: Dimensions.pageViewContainer,
                  //color: Colors.greenAccent,
                  child: PageView.builder(
                      itemCount: popularProducts.popularProductList.length,
                      controller: _pageController,
                      itemBuilder: (context, position) {
                        return _buildPageItem(position,
                            popularProducts.popularProductList[position]);
                      }),
                )
              : const CircularProgressIndicator(
                  color: AppColors.mainColor,
                );
        }),
        //dots
        GetBuilder<PopularProductController>(builder: (popularProducts) {
          return DotsIndicator(
            //Since DotIndicator Widget is drawn b4 items are updated, we use this code to prevent errors
            dotsCount: popularProducts.popularProductList.isEmpty
                ? 1
                : popularProducts.popularProductList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: Size.square(Dimensions.d9),
              activeSize: Size(Dimensions.d18, Dimensions.d9),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.d5),
              ),
            ),
          );
        }),
        SizedBox(height: Dimensions.d30),
        //Recommended text
        Container(
          margin: EdgeInsets.only(left: Dimensions.d30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const BigText(text: 'Recommended'),
              SizedBox(width: Dimensions.d10),
              Container(
                margin: EdgeInsets.only(bottom: Dimensions.d3),
                child: const BigText(text: '.', color: Colors.black26),
              ),
              SizedBox(width: Dimensions.d10),
              Container(
                margin: EdgeInsets.only(bottom: Dimensions.d2),
                child: const SmallText(text: 'Food pairing'),
              )
            ],
          ),
        ),
        //List of food and images of Recommended food
        GetBuilder<RecommendedProductController>(
            builder: (recommendedProducts) {
          return recommendedProducts.isLoaded
              ? ListView.builder(
                  itemCount: recommendedProducts.recommendedProductList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.getRecommendedFood(
                        index, RouteHelper.initial)),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.d20,
                          right: Dimensions.d20,
                          bottom: Dimensions.d10),
                      child: Row(
                        children: [
                          //Image section
                          Container(
                            width: Dimensions.listViewImageSize,
                            height: Dimensions.listViewImageSize,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.d20),
                              color: Colors.white38,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(AppConstants.BASE_URL +
                                    AppConstants.UPLOAD_URL +
                                    recommendedProducts
                                        .recommendedProductList[index].img!),
                              ),
                            ),
                          ),
                          //Text section
                          Expanded(
                            child: Container(
                              height: Dimensions.listViewTextContainerSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimensions.d20),
                                  bottomRight: Radius.circular(Dimensions.d20),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Dimensions.d10,
                                    right: Dimensions.d10,
                                    top: Dimensions.d10,
                                    bottom: Dimensions.d10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(
                                        text: recommendedProducts
                                            .recommendedProductList[index]
                                            .name!),
                                    //SizedBox(height: Dimensions.d10),
                                    const SmallText(
                                        text: 'With chinese characteristics'),
                                    //SizedBox(height: Dimensions.d10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        IconAndTextWidget(
                                          icon: Icons.circle_sharp,
                                          text: 'Normal',
                                          iconColor: AppColors.iconColor1,
                                        ),
                                        IconAndTextWidget(
                                          icon: Icons.location_on,
                                          text: '1.7km',
                                          iconColor: AppColors.mainColor,
                                        ),
                                        IconAndTextWidget(
                                          icon: Icons.access_time_rounded,
                                          text: '32min',
                                          iconColor: AppColors.iconColor2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const CircularProgressIndicator(
                  color: AppColors.mainColor,
                );
        }),
      ],
    );
  }

  Widget _buildPageItem(int index, ProductModel popularProduct) {
    Matrix4 matrix = Matrix4.identity();
    // debugPrint('INDEX  ' + index.toString());
    // debugPrint('CURRENT PAGE  ' + _currPageValue.toString());
    // debugPrint('CURRENT PAGE FLOOR  ' + _currPageValue.floor().toString());

    double currScale;

    //Scale all left pages while scrolling
    if (index == _currPageValue.floor()) {
      currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
    }
    //The right page is Scaled while scrolling or not. Subsequent right page is not scaled while scrolling
    else if (index == _currPageValue.floor() + 1) {
      currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
    }
    //Scale all the left pages while not scrolling
    else if (index == _currPageValue.floor() - 1) {
      currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
    }
    //Scale subsequent right page while scrolling
    else {
      currScale = _scaleFactor;
    }

    //final double _height = Dimensions.pageViewContainer;
    final double _height = Dimensions.pageViewImageContainer;
    double currTrans = _height * (1 - currScale) / 2;
    // Scale the y-axis with currScale value. Also transition the y-axis to fit to the center of the page view while scaling with currTrans value.
    matrix = Matrix4.diagonal3Values(1, currScale, 1)
      ..setTranslationRaw(0, currTrans, 0);

    return Transform(
      transform: matrix,
      child: GestureDetector(
        onTap: () {
          //Get.to(() => const PopularFoodDetail());
          Get.toNamed(RouteHelper.getPopularFood(index, RouteHelper.initial));
        },
        child: Stack(
          children: [
            Container(
              height: Dimensions.pageViewImageContainer,
              margin: EdgeInsets.symmetric(horizontal: Dimensions.d10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: index.isEven
                      ? const Color(0xFF69c5df)
                      : const Color(0xFF9294cc),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      //image: AssetImage('assets/image/food0.png'),
                      //We add the base url and '/uploads/' to complete the full path of the image, because the full path was not specified in the img section of the json
                      image: NetworkImage(AppConstants.BASE_URL +
                          AppConstants.UPLOAD_URL +
                          popularProduct.img!))),
            ),
            //In default Align takes the center position of it's parent widget
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.pageViewTextContainer,
                margin: EdgeInsets.only(
                    left: Dimensions.d30,
                    right: Dimensions.d30,
                    bottom: Dimensions.d30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.d20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFe8e8e8),
                        blurRadius: Dimensions.d5,
                        offset: Offset(0, Dimensions.d5),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-Dimensions.d5, 0),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(Dimensions.d5, 0),
                      ),
                    ]),
                child: Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.d15,
                    left: Dimensions.d15,
                    right: Dimensions.d15,
                  ),
                  child: AppColumn(text: popularProduct.name!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
