import 'package:flutter/material.dart';
import 'package:kariva/utils/dimensions.dart';

class AppIcon extends StatelessWidget {
  AppIcon({
    Key? key,
    required this.icon,
    this.iconColor = const Color(0xFF756d54),
    this.iconSize,
    this.backgroundColor = const Color(0xFFfcf4e4),
    this.size,
  }) : super(key: key);
  final IconData icon;
  final Color iconColor;
  final double? iconSize;
  final Color backgroundColor;
  double? size;

  @override
  Widget build(BuildContext context) {
    size = size ?? Dimensions.d40;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size! / 2),
        color: backgroundColor,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize ?? Dimensions.d16,
      ),
    );
  }
}
