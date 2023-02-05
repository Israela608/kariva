import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/data/repository/cart_repo.dart';
import 'package:kariva/models/cart_model.dart';
import 'package:kariva/models/products_model.dart';
import 'package:kariva/utils/colors.dart';

//CartController is reusable. It can be used in any controller that uses ProductModel as it's model.
class CartController extends GetxController {
  CartController({required this.cartRepo});
  final CartRepo cartRepo;

  //We use a Map instead of a normal List, so we can verify and hold the id of the item
  //The int section holds the id, the CartModel holds the item
  Map<int, CartModel> _items = {};

  Map<int, CartModel> get items => _items;

  //We convert the items map into a List, so we can use it in a ListView
  //e has both key and value, which represents int (id) and CartModel respectively
  //Since we only need our CardModel, we use only e.value to populate our List
  List<CartModel> get getItems => _items.entries.map((e) => e.value).toList();

  //For Storage and SharedPreferences
  List<CartModel> storageItems = [];

  void addItem(ProductModel product, int quantity) {
    //print('Length of the item is ' + _items.length.toString());

    //If items map already has an item with this id
    if (_items.containsKey(product.id)) {
      int totalQuantity = 0;
      //Update the item data with new data. In this case we update only the quantity parameter
      //We add the new quantity to the previous quantity to become totalQuantity.
      //The remaining parameters doesn't change since they're assigned value.{previous data}, so they retain their former values
      _items.update(product.id!, (value) {
        totalQuantity = value.quantity! + quantity;

        return CartModel(
          id: value.id,
          name: value.name,
          price: value.price,
          img: value.img,
          quantity: totalQuantity,
          isExist: true,
          //the item is updated exactly at the particular time
          time: DateTime.now().toString(),
          //We also add the ProductModel object, so when we click on the item, we can go to it's page
          product: product,
        );
      });

      //If the quantity is reduced to zero, then the item should be removed from the cart
      if (totalQuantity <= 0) {
        _items.remove(product.id);
      }
    } else {
      //Make sure the quantity is not zero
      if (quantity > 0) {
        //We use .putIfAbsent to check or verify if an item with this particular id is available in our map of items.
        //If it's absent, add the item
        _items.putIfAbsent(product.id!, () {
          /* print('adding item to the cart. ID: ' +
          product.id!.toString() +
          '  Name: ' +
          product.name!.toString() +
          '  Quantity: ' +
          quantity.toString());*/
          //We use ForEach to Loop through the map.
          //Because it is a map, it has both key and value parameters
          //key is the Id, value is the CartModel object of the Id
          /* _items.forEach((key, value) {
        print('$key  => quantity:  ' + value.quantity.toString());
      });*/
          return CartModel(
            id: product.id,
            name: product.name,
            price: product.price,
            img: product.img,
            quantity: quantity,
            //true, because we just added an item, so the item now exist in the Map
            isExist: true,
            //the item is added exactly at the particular time
            time: DateTime.now().toString(),
            //We also add the ProductModel object, so when we click on the item, we can go to it's page
            product: product,
          );
        });
      } else {
        Get.snackbar(
          'Item count',
          "You should at least add an item !",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
        );
      }
    }

    /* //Save the cart list to shared preferences
    cartRepo.addToCartList(getItems);

    update();*/
    addToCartList();
  }

  //Method that checks if a product already exists in the cart
  bool existInCart(ProductModel product) {
    //If the Id of the product is the key (or one of the keys) of the cart items map
    if (_items.containsKey(product.id)) {
      return true; //Then it already exists in the cart
    }
    return false; //Else it does not exist in the cart
  }

  //Method that returns the quantity of an item (or product) in the cart
  int getQuantity(ProductModel product) {
    int quantity = 0; //If the product is not in the cart, then quantity is 0
    //If the Id of the product is the key (or one of the keys) of the cart items map
    if (_items.containsKey(product.id)) {
      //Loop through the map
      _items.forEach((key, value) {
        //If the key matches the Id of the product
        if (key == product.id) {
          //Then quantity = the quantity of that item in the cart
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  //Method that gets the total quantities of items in the cart
  int get totalItems {
    int totalQuantityOfItemsInTheCart = 0;
    //Loop through the map and add all the quantities of the items together
    _items.forEach((key, value) {
      totalQuantityOfItemsInTheCart += value.quantity!;
    });
    return totalQuantityOfItemsInTheCart;
  }

  //Method that returns the total amount of all the items in the cart
  int get totalAmount {
    var total = 0;

    _items.forEach((key, value) {
      total += value.price! * value.quantity!;
    });

    return total;
  }

  //Method that saves all the items in the cart list to Storage (SharedPreferences) and updates the ui
  void addToCartList() {
    //Save the cart list to shared preferences
    cartRepo.addToCartList(getItems);
    update();
  }

  //Returns stored SharedPreferences data
  List<CartModel> getCartData() {
    //This is why it's a setter. You can use equal to for setting the variable
    setCart = cartRepo.getCartList();
    return storageItems;
  }

  //Setter that sets the Storage (SharedPreferences)
  //Sets the SharedPreferences data in our CartRepo to our storageItem list
  set setCart(List<CartModel> items) {
    storageItems = items;

    //We replace our map with stored data
    for (int i = 0; i < storageItems.length; i++) {
      //Since the map needs a key and a value, we use the id element of our item as the key
      _items.putIfAbsent(storageItems[i].product!.id!, () => storageItems[i]);
    }
  }

  //Method that stores all the items in the cart to cartHistory List during checkout
  void addToHistory() {
    cartRepo.addToCartHistoryList();
    clear();
  }

  //Clear the cart. Delete all items in the cart list
  void clear() {
    _items = {};
    update();
  }

  //Method that returns all the items in the cart history list (i.e all the items that have been checked out)
  List<CartModel> getCartHistoryList() {
    return cartRepo.getCartHistoryList();
  }

  //Method that deletes all stored cart related items including cart history items
  void clearCartHistory() {
    cartRepo.clearCartHistory();
    update();
  }

  //Method that deletes only all stored cart items and stored cart history items
  void removeCartSharedPreferences() {
    cartRepo.removeCartSharedPreferences();
  }

  //Setter that sets the items map for the cart
  set setItems(Map<int, CartModel> setItems) {
    _items = {};
    _items = setItems;
  }
}
