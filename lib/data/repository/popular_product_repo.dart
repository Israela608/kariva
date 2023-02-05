import 'package:get/get.dart';
import 'package:kariva/data/api/api_client.dart';
import 'package:kariva/utils/app_constants.dart';

//GetXService is used in Repositories and ApiClient. It's not used in controllers
class PopularProductRepo extends GetxService {
  PopularProductRepo({required this.apiClient});
  //Repository should have an instance of ApiClient, so we can call methods from ApiClient
  final ApiClient apiClient;

  //Method for getting response or data from the server through the ApiClient
  //We use the end-point of the uri here, since the base url has already been initialized in dependencies section
  Future<Response> getPopularProductList() async {
    return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);
  }
}
