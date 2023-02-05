import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/order_controller.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/utils/styles.dart';

class DeliveryOptions extends StatelessWidget {
  const DeliveryOptions({
    Key? key,
    required this.value,
    required this.title,
    required this.amount,
    required this.isFree,
  }) : super(key: key);

  final String value;
  final String title;
  final double amount;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        return Row(
          children: [
            Radio(
              value: value,
              groupValue: orderController.deliveryType,
              onChanged: (String? value) =>
                  orderController.setDeliveryType(value!),
              activeColor: Theme.of(context).primaryColor,
            ),
            SizedBox(width: Dimensions.d5),
            Text(
              title,
              style: robotoRegular,
            ),
            SizedBox(width: Dimensions.d5),
            Text(
              '(${value == 'take away' || isFree ? 'free' : '\$${amount / 10}'})',
              style: robotoMedium,
            ),
          ],
        );
      },
    );
  }
}
