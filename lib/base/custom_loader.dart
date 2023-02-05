import 'package:flutter/material.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Dimensions.d100,
        width: Dimensions.d100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.d50),
          color: AppColors.mainColor,
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
