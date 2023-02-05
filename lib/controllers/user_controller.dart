import 'package:get/get.dart';
import 'package:kariva/data/repository/user_repo.dart';
import 'package:kariva/models/response_model.dart';
import 'package:kariva/models/user_model.dart';

class UserController extends GetxController implements GetxService {
  UserController({required this.userRepo});
  final UserRepo userRepo;

  bool _isLoaded = false;
  UserModel _userModel = UserModel();

  bool get isLoaded => _isLoaded;
  UserModel get userModel => _userModel;

  //Method for getting user information data
  Future<ResponseModel> getUserInfo() async {
    //Get user info data
    Response response = await userRepo.getUserInfo();
    print('TEST  ' + response.body.toString());

    late ResponseModel responseModel;

    //If registration is successful
    if (response.statusCode == 200) {
      _userModel = UserModel.fromJson(response.body);
      _isLoaded = true;
      //Successful message
      responseModel = ResponseModel(true, 'Successfully');
    } else {
      //The message becomes the error message from the server
      responseModel = ResponseModel(false, response.statusText!);
    }

    update();
    return responseModel;
  }
}
