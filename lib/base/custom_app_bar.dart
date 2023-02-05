import 'package:flutter/material.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/widgets/big_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.backButtonExist = true,
    this.onBackPressed,
  }) : super(key: key);

  final String title;
  final bool backButtonExist;
  final Function? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BigText(
        text: title,
        color: Colors.white,
      ),
      centerTitle: true,
      backgroundColor: AppColors.mainColor,
      elevation: 0,
      //If we need the backButton
      leading: backButtonExist
          //Place a back button
          ? IconButton(
              //If there is an onPressed function, we use it, else we go back to home page
              onPressed: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.pushReplacementNamed(
                      context, RouteHelper.getInitial()),
              //Get.toNamed(RouteHelper.getInitial()),
              icon: const Icon(Icons.arrow_back_ios),
            )
          : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.maxFinite, 53);
}
