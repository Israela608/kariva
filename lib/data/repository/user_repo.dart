import 'package:get/get.dart';
import 'package:kariva/data/api/api_client.dart';
import 'package:kariva/utils/app_constants.dart';

class UserRepo {
  UserRepo({required this.apiClient});
  final ApiClient apiClient;

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.USER_INFO_URI);
  }
}
