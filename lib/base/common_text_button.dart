import 'package:flutter/material.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/big_text.dart';

class CommonTextButton extends StatelessWidget {
  const CommonTextButton({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.d20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.d20),
          color: AppColors.mainColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 10,
              color: AppColors.mainColor.withOpacity(0.3),
            )
          ]),
      child: Center(child: BigText(text: text, color: Colors.white)),
    );
  }
}
