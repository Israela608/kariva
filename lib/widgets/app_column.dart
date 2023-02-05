import 'package:flutter/material.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/big_text.dart';
import 'package:kariva/widgets/icon_and_text_widget.dart';

import 'small_text.dart';

class AppColumn extends StatelessWidget {
  const AppColumn({Key? key, required this.text, this.textSize})
      : super(key: key);
  final String text;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: text, size: textSize),
        SizedBox(height: Dimensions.d10),
        Row(
          children: [
            ...List.generate(
                5,
                (index) => Icon(
                      Icons.star,
                      color: AppColors.mainColor,
                      size: Dimensions.d15,
                    )),
            SizedBox(width: Dimensions.d10),
            const SmallText(text: '4.5'),
            SizedBox(width: Dimensions.d10),
            const SmallText(text: '1287'),
            SizedBox(width: Dimensions.d10),
            const SmallText(text: 'comments')
          ],
        ),
        SizedBox(height: Dimensions.d20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        )
      ],
    );
  }
}
