import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kariva/controllers/auth_controller.dart';

class NotificationHelper {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    //Initialize the android settings
    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    //Initialize the IOS settings
    var iOSInitialize = const DarwinInitializationSettings();
    //The new settings function with both android and IOS settings
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    //We call/initialize it in our flutter local notification plugin function
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        //This is the callback function for sending payload in the foreground.
        //This will redirect you to a new page from the foreground
        onDidReceiveNotificationResponse:
            (NotificationResponse? payload) async {
      try {
        if (payload != null && payload.payload!.isNotEmpty) {
          /* Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return NewScreen(info: payload.payload.toString());
          }));*/
        } else {
          //Get.toNamed(RouteHelper.getNotificationRoute());
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
      return;
    });

    //Method that listen to messages coming from firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('....................onMessage...................');
      print('onMessage: ${message.notification?.title}/'
          '${message.notification?.body}/'
          '${message.notification?.titleLocKey}');

      showNotification(message, flutterLocalNotificationsPlugin);

      if (Get.find<AuthController>().userLoggedIn()) {
        //Get.find<OrderController>().getRunningOrders(1);
        //Get.find<OrderController>().getHistoryOrders(1);
        //Get.find<NotificationController>().getNotificationList(true);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('....................onMessage...................');
      print('onMessage: ${message.notification?.title}/'
          '${message.notification?.body}/'
          '${message.notification?.titleLocKey}');

      try {
        if (message.notification?.titleLocKey != null) {
          //Get.toNamed(RouteHelper.getOrderDetailsRoute(
          //int.parse(message.notification!.titleLocKey!)));
        } else {
          //Get.toNamed(RouteHelper.getNotificationRoute());
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  //Method that shows the notification
  static Future<void> showNotification(
      RemoteMessage message, FlutterLocalNotificationsPlugin fln) async {
    //Notification plugin settings
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body!,
      htmlFormatBigText: true,
      contentTitle: message.notification!.title!,
      htmlFormatContentTitle: true,
    );

    //Android platform specific settings
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id_1',
      'Kariva',
      importance: Importance.high,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
      //Play this sound when the user gets a notification.
      //The sound is in android-> app-> src-> main-> res-> raw folder
      //sound: const RawResourceAndroidNotificationSound('notification'),
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    //Show the message on device
    await fln.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      //payload: message.data['body'],
    );
  }
}
