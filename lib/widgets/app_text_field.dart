import 'package:flutter/material.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {Key? key,
      required this.textController,
      required this.hintText,
      required this.icon,
      this.isObscure = false,
      this.maxLines = false})
      : super(key: key);

  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final bool isObscure;
  final bool maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.d20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.d15),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(1, 1),
            color: Colors.grey.withOpacity(0.2),
          )
        ],
      ),
      child: TextField(
        controller: textController,
        obscureText: isObscure,
        maxLines: maxLines ? 3 : 1,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: AppColors.yellowColor,
          ),
          //focusedBorder
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.d15),
            borderSide: const BorderSide(
              width: 1.0,
              color: Colors.white,
            ),
          ),
          //enabledBorder
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.d15),
            borderSide: const BorderSide(
              width: 1.0,
              color: Colors.white,
            ),
          ),
          //border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.d15),
          ),
        ),
      ),
    );
  }
}
