import 'package:flutter/material.dart';
import 'package:kariva/utils/dimensions.dart';

class BigText extends StatelessWidget {
  const BigText({
    Key? key,
    required this.text,
    this.color = const Color(0xFF332d2b),
    this.size,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);
  final String text;
  final Color? color;
  final double? size;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'Roboto',
        color: color,
        fontSize: size ?? Dimensions.d20,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
