import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kariva/base/custom_loader.dart';
import 'package:kariva/base/show_custom_snackbar.dart';
import 'package:kariva/controllers/auth_controller.dart';
import 'package:kariva/models/signup_body_model.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/app_text_field.dart';
import 'package:kariva/widgets/big_text.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();

    var signUpImages = [
      'assets/image/t.png',
      'assets/image/f.png',
      'assets/image/g.png',
    ];

    void _registration(AuthController authController) {
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar(message: 'Type in your name', title: 'Name');
      } else if (phone.isEmpty) {
        showCustomSnackBar(
            message: 'Type in your phone number', title: 'Phone number');
      } else if (email.isEmpty) {
        showCustomSnackBar(
            message: 'Type in your email address', title: 'Email address');
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar(
            message: 'Type in a valid email address',
            title: 'Valid email address');
      } else if (password.isEmpty) {
        showCustomSnackBar(message: 'Type in your password', title: 'Password');
      } else if (password.length < 6) {
        showCustomSnackBar(
            message: 'Password cannot be less than six characters',
            title: 'Password');
      } else {
        SignUpModel signUpBody = SignUpModel(
          name: name,
          phone: phone,
          email: email,
          password: password,
        );

        //Register the user using the given information
        //value is an object of ResponseModel that is returned during registration
        authController.registration(signUpBody).then((value) {
          if (value.isSuccess) {
            showCustomSnackBar(
              message: 'All went well',
              title: 'Perfect',
              isError: false,
            );
            print('Success registration');
            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(message: value.message);
          }
        });

        print(signUpBody.toString());
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
                      //your email
                      AppTextField(
                        textController: emailController,
                        hintText: 'Email',
                        icon: Icons.email,
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
                      //your name
                      AppTextField(
                        textController: nameController,
                        hintText: 'Name',
                        icon: Icons.person,
                      ),
                      SizedBox(height: Dimensions.d20),
                      //your phone
                      AppTextField(
                        textController: phoneController,
                        hintText: 'Phone',
                        icon: Icons.phone,
                      ),
                      SizedBox(height: Dimensions.d40),
                      //sign up button
                      InkWell(
                        onTap: () {
                          _registration(_authController);
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
                              text: 'Sign up',
                              size: Dimensions.d30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.d10),
                      //tag line
                      RichText(
                        text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.back(),
                          text: 'Have an account already?',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: Dimensions.d20,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.screenHeight * 0.05),
                      //sign up options
                      RichText(
                        text: TextSpan(
                          text: 'Sign up using one of the following methods',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: Dimensions.d16,
                          ),
                        ),
                      ),
                      Wrap(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: EdgeInsets.all(Dimensions.d8),
                            child: CircleAvatar(
                              radius: Dimensions.d30,
                              backgroundImage: AssetImage(signUpImages[index]),
                            ),
                          ),
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
