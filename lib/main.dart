import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kariva/helper/notification_helper.dart';
import 'package:kariva/routes/route_helper.dart';
import 'package:kariva/utils/colors.dart';

import 'helper/dependencies.dart' as dep;

//Handler for implementing background firebase notification message
Future<dynamic> myBackgroundHandler(RemoteMessage message) async {
  print(
      'onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  //This will make sure our dependencies are loaded correctly
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //wait till all dependencies are loaded
  await dep.init();

  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);
      /*FirebaseMessaging.onBackgroundMessage(
          (message) => myBackgroundHandler(message));*/
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Initialize the controller. You can use Get.find<> to locate an item saved in GetX internally
    //Get.find<PopularProductController>().getPopularProductList();
    //Get.find<RecommendedProductController>().getRecommendedProductList();
    //Get.find<LocationController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.mainColor,
        fontFamily: 'Lato',
      ),
      //home: MainFoodPage(),
      //home: CartPage(),
      //home: const SplashPage(),
      //home: SignUpPage(),
      //home: SignInPage(),
      //home: AddAddressPage(),
      initialRoute: RouteHelper.getSplashPage(),
      getPages: RouteHelper.routes,
    );
  }
}
