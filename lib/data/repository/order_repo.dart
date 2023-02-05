import 'package:get/get.dart';
import 'package:kariva/data/api/api_client.dart';
import 'package:kariva/models/place_order_model.dart';
import 'package:kariva/utils/app_constants.dart';

class OrderRepo {
  OrderRepo({required this.apiClient});
  final ApiClient apiClient;

  //Method that posts the cart order to the server
  Future<Response> placeOrder(PlaceOrderBody placeOrder) async {
    return await apiClient.postData(
        AppConstants.PLACE_ORDER_URI, placeOrder.toJson());
  }

  //Method that gets the list of orders from the server
  Future<Response> getOrderList() async {
    return await apiClient.getData(AppConstants.ORDER_LIST_URI);
  }
}
