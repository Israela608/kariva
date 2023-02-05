import 'package:flutter/material.dart';
import 'package:kariva/utils/dimensions.dart';

class SmallText extends StatelessWidget {
  const SmallText(
      {Key? key,
      required this.text,
      this.color = const Color(0xFFccc7c5),
      this.size,
      this.height = 1.2})
      : super(key: key);
  final String text;
  final Color? color;
  final double? size;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size ?? Dimensions.d12,
        height: height,
      ),
    );
  }
}
