import 'package:get/get.dart';
import 'package:kariva/data/repository/recommended_product_repo.dart';
import 'package:kariva/models/products_model.dart';

class RecommendedProductController extends GetxController {
  RecommendedProductController({required this.recommendedProductRepo});
  //Controller should have an instance of Repository, so we can call methods from Repository.
  //UI depends on the controller, Controller depends on the Repository, Repository depends on the ApiClient and the ApiClient depends on the Server
  final RecommendedProductRepo recommendedProductRepo;

  //We store the data from the repository in a list
  List<dynamic> _recommendedProductList = [];
  bool _isLoaded = false;

  //getter for the list
  List<dynamic> get recommendedProductList => _recommendedProductList;
  bool get isLoaded => _isLoaded;

  //Method for getting the Response or data from the repository and assigning the data to list
  Future<void> getRecommendedProductList() async {
    //get the response from the repository
    Response response =
        await recommendedProductRepo.getRecommendedProductList();
    //If data was received successfully, convert and assign to list. status code of 200 means successful
    if (response.statusCode == 200) {
      //print('GOT RECOMMENDED PRODUCTS');
      _recommendedProductList = []; //initialize the list
      //.addAll is an Iterable, so we iterate and add all the data to the popularProductList
      //The model method, Product.fromJson() maps the response data (response.body is the data of the response) in the products_model
      //After mapping, we get the products List from the model and then add all the items in that list to the recommendedProductList in this controller
      _recommendedProductList.addAll(Product.fromJson(response.body).products);
      //print(_recommendedProductList);
      _isLoaded = true;
      update(); //Same as setState() for statefulWidget or notifyListener() for providers
    } else {}
  }
}
