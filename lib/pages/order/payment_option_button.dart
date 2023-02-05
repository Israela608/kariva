import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/order_controller.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/utils/styles.dart';

class PaymentOptionButton extends StatelessWidget {
  const PaymentOptionButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      //True if the selected tile matches the index
      bool _isSelected = orderController.paymentIndex == index;
      return InkWell(
        onTap: () => orderController.setPaymentIndex(index),
        child: Container(
          padding: EdgeInsets.only(bottom: Dimensions.d5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.d5),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ]),
          child: ListTile(
            leading: Icon(
              icon,
              size: Dimensions.d40,
              color: _isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
            ),
            title: Text(
              title,
              style: robotoMedium.copyWith(fontSize: Dimensions.d20),
            ),
            subtitle: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(
                color: Theme.of(context).disabledColor,
                fontSize: Dimensions.d16,
              ),
            ),
            trailing: _isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
        ),
      );
    });
  }
}
