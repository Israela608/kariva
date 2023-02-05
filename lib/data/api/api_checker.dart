import 'package:get/get.dart';
import 'package:kariva/base/show_custom_snackbar.dart';
import 'package:kariva/routes/route_helper.dart';

class ApiChecker {
  static void checkApi(Response response) {
    //If the user is not logged in
    if (response.statusCode == 401) {
      //Go to sign in page
      Get.offNamed(RouteHelper.getSignInPage());
    } else {
      showCustomSnackBar(message: response.statusText!);
    }
  }
}
