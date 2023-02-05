import 'dart:convert';

import 'package:kariva/models/cart_model.dart';
import 'package:kariva/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  CartRepo({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  //Shared preferences accepts String only
  List<String> cart = []; //Stores all items added to cart
  List<String> cartHistory = []; //Stores all items in cart during checkout

  //Method for saving cart data into Shared Preferences
  //This method takes in a CartModel list object, converts into String and saves it in SharedPreferences.
  //Here we convert List<CartModel> into List<String> and save
  void addToCartList(List<CartModel> cartList) {
    // sharedPreferences.remove(AppConstants.CART_LIST);
    // sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    // return;
    cart = [];
    //We want all the elements in the cart storage to have the same time.
    var time = DateTime.now().toString();

    //We loop through cartList, convert each item into String by encoding (using jsonEncode()), and save each of the item into our cart List of String
    cartList.forEach((element) {
      //Any time a new item is added to the cartList, we replace all the time of all the items in cartList to this particular instance of time before storing
      //Since the items in the cart are arranged one after the other (Since it is a list), we don't need the time for this arrangement
      //The main reason we want this is so that we can group checkout items in the history tab.
      //So groups of items can be can be arranged based on the time the cart was sent for checkout
      element.time = time;
      cart.add(jsonEncode(element));
    });

    //We save our list of String into Shared Preferences.
    sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
    //print(sharedPreferences.getStringList(AppConstants.CART_LIST));
    //getCartList();
  }

  void addToCartHistoryList() {
    //If we previously had any information stored in cartHistoryList Shared Preference,
    // we need to keep it and also store the new ones
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory =
          sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    for (int i = 0; i < cart.length; i++) {
      //print('history list  ' + cart[i]);
      cartHistory.add(cart[i]);
    }

    sharedPreferences.setStringList(
        AppConstants.CART_HISTORY_LIST, cartHistory);

    //Remove cart from memory
    cart = [];
    // print('The length of the history is   ' +
    //     getCartHistoryList().length.toString());

    /*for (int i = 0; i < getCartHistoryList().length; i++) {
      print('The time for the order is  ' +
          getCartHistoryList()[i].time.toString());
    }*/
  }

  //Method for getting cart data from Shared Preferences
  //Here we convert List<String> into List<CartModel> and save
  List<CartModel> getCartList() {
    //List<String> carts = [];

    //We check if the Key exists
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      //Retrieve every information (Which is in String) and save it to carts List of String
      //carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
      cart = [];
      cart = sharedPreferences.getStringList(AppConstants.CART_LIST)!;

      //print('inside getCartList  ' + cart.toString());
    }

    List<CartModel> cartList = [];

    //We loop through the List of String, decode each item into a CartModel and add it to the cartList List of CartModel
    /* carts.forEach(
        (element) => cartList.add(CartModel.fromJson(jsonDecode(element))));*/

    cart.forEach(
        (element) => cartList.add(CartModel.fromJson(jsonDecode(element))));

    return cartList;
  }

  List<CartModel> getCartHistoryList() {
    //List<String> cartHistory = [];

    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory = [];
      cartHistory =
          sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;

      //print('inside getCartHistoryList  ' + cartHistory.toString());
    }

    List<CartModel> cartHistoryList = [];

    cartHistory.forEach((element) =>
        cartHistoryList.add(CartModel.fromJson(jsonDecode(element))));

    return cartHistoryList;
  }

  /* //Delete all cart stored items
  void removeCart() {
    //Remove from memory
    cart = [];
    //Remove from storage
    sharedPreferences.remove(AppConstants.CART_LIST);
  }*/

  //Delete all stored cart items and stored cart history items and from memory
  void clearCartHistory() {
    //Remove all cart items from memory
    cart = [];
    //Remove cart history from memory
    cartHistory = [];
    //Remove all stored cart items and stored cart history items from storage
    removeCartSharedPreferences();
  }

  //Delete only all stored cart items and stored cart history items
  void removeCartSharedPreferences() {
    sharedPreferences.remove(AppConstants.CART_LIST);
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
  }
}
