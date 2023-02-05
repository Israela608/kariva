import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/base/custom_loader.dart';
import 'package:kariva/base/show_custom_snackbar.dart';
import 'package:kariva/controllers/auth_controller.dart';
import 'package:kariva/pages/auth/sign_up_page.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/app_text_field.dart';
import 'package:kariva/widgets/big_text.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    //var emailController = TextEditingController();
    var passwordController = TextEditingController();

    void _login(AuthController authController) {
      String phone = phoneController.text.trim();
      //String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (phone.isEmpty) {
        showCustomSnackBar(
            message: 'Type in your phone number', title: 'Phone number');
      } else if (password.isEmpty) {
        showCustomSnackBar(message: 'Type in your password', title: 'Password');
      } else if (password.length < 6) {
        showCustomSnackBar(
            message: 'Password cannot be less than six characters',
            title: 'Password');
      } else {
        //Login the user using the email and password
        //value is an object of ResponseModel that is returned during registration
        authController.login(phone: phone, password: password).then((value) {
          if (value.isSuccess) {
            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(message: value.message);
          }
        });

        //print(signUpBody.toString());
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        builder: (_authController) {
          return !_authController.isLoading
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: Dimensions.screenHeight * 0.05),
                      //app logo
                      Container(
                        height: Dimensions.screenHeight * 0.25,
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: Dimensions.d80,
                            backgroundImage: const AssetImage(
                                'assets/image/logo part 1.png'),
                          ),
                        ),
                      ),
                      //welcome
                      Container(
                        margin: EdgeInsets.only(left: Dimensions.d20),
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: TextStyle(
                                fontSize: Dimensions.d70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Sign into your account',
                              style: TextStyle(
                                fontSize: Dimensions.d20,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.d20),
                      //your email
                      AppTextField(
                        textController: phoneController,
                        hintText: 'Phone',
                        icon: Icons.phone,
                      ),
                      SizedBox(height: Dimensions.d20),
                      //your password
                      AppTextField(
                        textController: passwordController,
                        hintText: 'Password',
                        icon: Icons.password_sharp,
                        isObscure: true,
                      ),
                      SizedBox(height: Dimensions.d20),
                      //tag line
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: Dimensions.d20),
                        child: RichText(
                          text: TextSpan(
                            //recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                            text: 'Sign into your account',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.d20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.screenHeight * 0.05),
                      //sign in button
                      InkWell(
                        onTap: () {
                          _login(_authController);
                        },
                        child: Container(
                          width: Dimensions.screenWidth / 2,
                          height: Dimensions.screenHeight / 13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.d30),
                            color: AppColors.mainColor,
                          ),
                          child: Center(
                            child: BigText(
                              text: 'Sign in',
                              size: Dimensions.d30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.screenHeight * 0.05),
                      //sign up options
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: Dimensions.d20,
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => const SignUpPage(),
                                    transition: Transition.fadeIn),
                              text: 'Create',
                              style: TextStyle(
                                color: AppColors.mainBlackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.d20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const CustomLoader();
        },
      ),
    );
  }
}
