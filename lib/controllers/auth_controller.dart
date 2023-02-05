import 'package:get/get.dart';
import 'package:kariva/data/repository/auth_repo.dart';
import 'package:kariva/models/response_model.dart';
import 'package:kariva/models/signup_body_model.dart';

class AuthController extends GetxController implements GetxService {
  AuthController({required this.authRepo});
  final AuthRepo authRepo;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  //Method for Registration of user
  Future<ResponseModel> registration(SignUpModel signUpModel) async {
    _isLoading = true;
    update();
    //Post the registration data
    Response response = await authRepo.registration(signUpModel);

    late ResponseModel responseModel;

    //If registration is successful
    if (response.statusCode == 200) {
      //Save the user token
      authRepo.saveUserToken(response.body['token']);
      //Store the token as the message in the ResponseModel
      responseModel = ResponseModel(true, response.body['token']);
    } else {
      //The message becomes the error message from the server
      responseModel = ResponseModel(false, response.statusText!);
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  //Method for Login of user
  Future<ResponseModel> login(
      {required String phone, required String password}) async {
    _isLoading = true;
    update();
    //Post the login data
    Response response = await authRepo.login(phone, password);

    late ResponseModel responseModel;

    //If login is successful
    if (response.statusCode == 200) {
      //Save the user token
      //We only need the 'token' parameter from the response body, not the entire body
      authRepo.saveUserToken(response.body['token']);
      print('My token is   ' + response.body['token']);
      //Store the token as the message in the ResponseModel
      responseModel = ResponseModel(true, response.body['token']);
    } else {
      //The message becomes the error message from the server
      responseModel = ResponseModel(false, response.statusText!);
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  //Method that saves the user phone number and password, so we can use it next time we log in
  void saveNumberAndPassword(
      {required String number, required String password}) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  // Checks if there is a user token available, i.e user is Logged in
  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  //Clear all login data
  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  //Method that posts the updated user device firebase token to the server
  Future<void> updateToken() async {
    await authRepo.updateToken();
  }
}
