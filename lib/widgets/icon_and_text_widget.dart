import 'package:flutter/material.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/small_text.dart';

class IconAndTextWidget extends StatelessWidget {
  const IconAndTextWidget(
      {Key? key,
      required this.icon,
      required this.text,
      required this.iconColor})
      : super(key: key);
  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: Dimensions.d24,
        ),
        SizedBox(width: Dimensions.d5),
        SmallText(text: text),
      ],
    );
  }
}
