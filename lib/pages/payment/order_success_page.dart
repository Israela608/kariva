import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/base/custom_button.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage(
      {Key? key, required this.orderID, required this.status})
      : super(key: key);
  final String orderID;
  final int status;

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(const Duration(seconds: 1), () {
        /* Get.dialog(PaymentFailedDialog(orderID: orderID),
            barrierDismissible: false);*/
      });
    }
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                status == 1
                    ? Icons.check_circle_outline
                    : Icons.warning_amber_outlined,
                size: Dimensions.d100,
                color: AppColors.mainColor,
              ),
              SizedBox(height: Dimensions.d30),
              Text(
                status == 1
                    ? 'You placed the order successfully'
                    : 'Your order failed',
                style: TextStyle(height: Dimensions.d20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.d20, vertical: Dimensions.d10),
                child: Text(
                  status == 1 ? 'Successful order' : 'Failed order',
                  style: TextStyle(
                      fontSize: Dimensions.d20,
                      color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimensions.d10),
              Padding(
                padding: EdgeInsets.all(Dimensions.d10),
                child: CustomButton(
                  buttonText: 'Back to Home',
                  onPressed: () => Get.offAllNamed(RouteHelper.getInitial()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
