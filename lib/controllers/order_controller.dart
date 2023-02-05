import 'package:get/get.dart';
import 'package:kariva/data/repository/order_repo.dart';
import 'package:kariva/models/order_model.dart';
import 'package:kariva/models/place_order_model.dart';

class OrderController extends GetxController implements GetxService {
  OrderController({required this.orderRepo});
  OrderRepo orderRepo;

  bool _isLoading = false;
  late List<OrderModel> _currentOrderList;
  late List<OrderModel> _historyOrderList;
  int _paymentIndex = 0;
  String _deliveryType = 'delivery';
  String _foodNote = '';

  bool get isLoading => _isLoading;
  List<OrderModel> get currentOrderList => _currentOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  int get paymentIndex => _paymentIndex;
  String get deliveryType => _deliveryType;
  String get foodNote => _foodNote;

  //Method that sends the cart order to the server
  Future<void> placeOrder(PlaceOrderBody placeOrder, Function callback) async {
    _isLoading = true;
    // print('START');
    Response response = await orderRepo.placeOrder(placeOrder);
    print('STATUS CODE:   ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      print('SUCCESS CONTROLLER');
      _isLoading = false;
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID);
    } else {
      print('FAILURE CONTROLLER');
      //orderID of -1 means invalid
      callback(false, response.statusText!, '-1');
    }
    //print('END');
  }

  //Method that gets the list of orders from the server for this user
  Future<void> getOrderList() async {
    _isLoading = true;

    Response response = await orderRepo.getOrderList();

    if (response.statusCode == 200) {
      _currentOrderList = [];
      _historyOrderList = [];

      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);

        //If any of this is true, then the order is still pending, so we put it in the currentOrderList
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'accepted' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'handover' ||
            orderModel.orderStatus == 'picked_up') {
          _currentOrderList.add(orderModel);
        } else {
          //If none of those condition is true, then the order is completed adn is now history
          _historyOrderList.add(orderModel);
        }
      });
    } else {
      //If there is any error while retrieving data from the server
      _currentOrderList = [];
      _historyOrderList = [];
    }

    print('The length of the current orders:   ' +
        _currentOrderList.length.toString());
    print('The length of the history orders:   ' +
        _historyOrderList.length.toString());

    _isLoading = false;
    update();
  }

  //Method that sets the payment type according to the index ( 0 for 'cash on delivery', 1 for 'digital payment')
  void setPaymentIndex(int index) {
    _paymentIndex = index;
    update();
  }

  //Method that sets the delivery type (Home delivery or Take away)
  void setDeliveryType(String type) {
    _deliveryType = type;
    update();
  }

  //Method that sets the food note text
  void setFoodNote(String note) {
    _foodNote = note;
  }
}
