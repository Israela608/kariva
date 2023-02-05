import 'package:flutter/material.dart';
import 'package:kariva/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      this.onPressed,
      required this.buttonText,
      this.transparent = false,
      this.margin,
      this.height,
      this.width,
      this.fontSize,
      this.radius,
      this.icon})
      : super(key: key);

  final VoidCallback? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButton = TextButton.styleFrom(
        //If there is no onPressed callback
        backgroundColor: onPressed == null
            //Set the color to disabled color
            ? Theme.of(context).disabledColor
            //If there is an onPressed callback, and transparent is true
            : transparent
                //Set the color to transparent
                ? Colors.transparent
                //Else set the color to the primary color
                : Theme.of(context).primaryColor,
        minimumSize: Size(
          width ?? Dimensions.screenWidth,
          height ?? Dimensions.d50,
        ),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? Dimensions.d5)));
    return Center(
      child: SizedBox(
        width: width ?? Dimensions.screenWidth,
        height: height ?? Dimensions.d50,
        child: TextButton(
          onPressed: onPressed,
          style: _flatButton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //If there is an icon
              icon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: Dimensions.d5),
                      child: Icon(
                        icon,
                        color: transparent
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                      ),
                    )
                  : const SizedBox(),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: fontSize ?? Dimensions.d16,
                  color: transparent
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
