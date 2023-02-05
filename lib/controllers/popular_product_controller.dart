import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/cart_controller.dart';
import 'package:kariva/data/repository/popular_product_repo.dart';
import 'package:kariva/models/cart_model.dart';
import 'package:kariva/models/products_model.dart';
import 'package:kariva/utils/colors.dart';

class PopularProductController extends GetxController {
  PopularProductController({required this.popularProductRepo});
  //Controller should have an instance of Repository, so we can call methods from Repository.
  //UI depends on the controller, Controller depends on the Repository, Repository depends on the ApiClient and the ApiClient depends on the Server
  final PopularProductRepo popularProductRepo;

  //We store the data from the repository in a list
  List<dynamic> _popularProductList = [];
  bool _isLoaded = false;
  //Present quantity of the product to be added to the cart
  late int _quantity;
  //Quantity of the product already added to the cart.
  //If the product has not been added to the cart, inCartItem is zero
  late int _inCartItems;
  //Every product page controller must have an instance of CartController, so we can use and modify cart items for this product controller
  //_cart in this case is our object of CartController for use in our popular food controller
  late CartController _cart;

  void initialize(ProductModel product, CartController cart) {
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;

    var exist = false;
    exist = _cart.existInCart(product);
    //print('exist or not:   ' + exist.toString());
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
    }
    //print('The quantity in the cart is   ' + _inCartItems.toString());
  }

  //getter for the list
  List<dynamic> get popularProductList => _popularProductList;
  bool get isLoaded => _isLoaded;
  int get quantity => _quantity;
  //Return both the previous quantity already added to the cart (inCartItems)
  // and the current quantity to be added to the cart (quantity)
  int get totalQuantityOfTheItem => _inCartItems + quantity;

  //Method for getting the Response or data from the repository and assigning the data to list
  //This is the only methods in this controller that is directly related to this controller (i.e it interacts with PopularProductRepo). The other methods are reusable
  Future<void> getPopularProductList() async {
    //get the response from the repository
    Response response = await popularProductRepo.getPopularProductList();
    //If data was received successfully, convert and assign to list. status code of 200 means successful
    if (response.statusCode == 200) {
      //print('GOT POPULAR PRODUCTS');
      _popularProductList = []; //initialize the list
      //.addAll is an Iterable, so we iterate and add all the data to the popularProductList
      //The model method, Product.fromJson() maps the response data (response.body is the data of the response) in the products_model
      //After mapping, we get the products List from the model and then add all the items in that list to the popularProductList in this controller
      _popularProductList.addAll(Product.fromJson(response.body).products);
      //print(_popularProductList);
      _isLoaded = true;
      update(); //Same as setState() for statefulWidget or notifyListener() for providers
    } else {}
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
      //print('increment   ' + _quantity.toString());
    } else {
      _quantity = checkQuantity(_quantity - 1);
      //print('decrement   ' + _quantity.toString());
    }
    update();
  }

  //This method ensures that the total quantity (inCartItems + quantity) is not less
  // than zero or greater than the maximum allowed total quantity, by all means
  int checkQuantity(int quantity) {
    int maximumQuantity = 20;
    //If the total quantity of the item selected is less than zero
    if ((_inCartItems + quantity) < 0) {
      Get.snackbar(
        'Item count',
        "You can't reduce more !",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );

      //If the item has already been added to the cart, then to make sure the total quantity (inCartItem + quantity)
      // is zero, we have to make inCartItems zero. We do that by setting the value of quantity to the negative of inCartItem,
      // so they cancel each other, and the total item becomes zero
      if (_inCartItems > 0) {
        _quantity = -_inCartItems;
        return _quantity;
      }
      //else return zero as quantity (Since the item has not been added to the cart,
      // inCartItem is still zero, which means the total quantity is zero)
      return 0;
    }
    //If the total quantity of the item selected is greater than the maximum allowable quantity
    else if ((_inCartItems + quantity) > maximumQuantity) {
      Get.snackbar(
        'Item count',
        "You can't add more !",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );

      //If the item has already been added to the cart, return the new quantity,
      // so that the total quantity becomes the maximum allowed quantity
      if (_inCartItems > 0) {
        return _quantity;
      }

      //else return the maximum allowed quantity
      return maximumQuantity;
    } else {
      return quantity;
    }
  }

  void addItem(ProductModel product) {
    _cart.addItem(product, quantity);
    _quantity = 0;
    _inCartItems = _cart.getQuantity(product);
    _cart.items.forEach((key, value) {
      print('The id is ' +
          value.id.toString() +
          '  The quantity is ' +
          value.quantity.toString());
    });
    update();
  }

  //Method that gets the total quantities of items in the food cart
  int get totalItems {
    return _cart.totalItems;
  }

  //Price * total quantity of an Item
  int totalItemPrice(ProductModel product) {
    return product.price! * totalQuantityOfTheItem;
  }

  //Method that returns the list of items in our cart
  List<CartModel> get getItems {
    return _cart.getItems;
  }
}
