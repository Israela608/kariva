import 'package:flutter/material.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/app_icon.dart';
import 'package:kariva/widgets/big_text.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget(
      {Key? key, this.onPressed, required this.appIcon, required this.bigText})
      : super(key: key);
  final dynamic onPressed;
  final AppIcon appIcon;
  final BigText bigText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(
          left: Dimensions.d20,
          top: Dimensions.d10,
          bottom: Dimensions.d10,
        ),
        child: Row(
          children: [
            appIcon,
            SizedBox(width: Dimensions.d20),
            bigText,
          ],
        ),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            blurRadius: 1,
            offset: const Offset(0, 2),
            color: Colors.grey.withOpacity(0.2),
          )
        ]),
      ),
    );
  }
}
