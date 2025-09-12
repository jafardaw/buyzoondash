import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// تعريف وإعداد مكتبة الإشعارات المحلية
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {},
  );
}

// دالة لمعالجة إشعارات الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// دالة لعرض الإشعار المحلي
void showLocalNotification(RemoteMessage message) async {
  final NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      channelDescription: 'Description for the channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    ),
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode, // معرف فريد للإشعار
    message.notification!.title,
    message.notification!.body,
    notificationDetails,
  );
}

// دالة إعداد الإشعارات
Future<void> setupNotifications() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showLocalNotification(message);
    }
  });

  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");
  saveTokenToDatabase(token);
}

void saveTokenToDatabase(String? token) async {
  if (token != null) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
    print("FCM Token saved to SharedPreferences: $token");
  }
}

// // // هنا يمكنك إضافة دالة جديدة للتعامل مع النقر على الإشعار المحلي
// // void onLocalNotificationTap(NotificationResponse response) {
// //   if (response.payload != null) {
// //     // هنا يتم توجيه المستخدم إلى صفحة الإشعارات
// //     AppRoutes.router.go('/notifications');
// //   }
// // }

// // Future<void> initializeLocalNotifications() async {
// //   const AndroidInitializationSettings initializationSettingsAndroid =
// //       AndroidInitializationSettings('@mipmap/ic_launcher');

// //   final DarwinInitializationSettings initializationSettingsDarwin =
// //       DarwinInitializationSettings();

// //   final InitializationSettings initializationSettings = InitializationSettings(
// //     android: initializationSettingsAndroid,
// //     iOS: initializationSettingsDarwin,
// //   );

// //   await flutterLocalNotificationsPlugin.initialize(
// //     initializationSettings,
// //     // هذا هو السطر الجديد الذي يربط النقر على الإشعار بالدالة
// //     onDidReceiveNotificationResponse: onLocalNotificationTap,
// //   );
// // }

// // // ... بقية الكود
// // // لا تنسَ تعديل دالة showLocalNotification
// // void showLocalNotification(RemoteMessage message) async {
// //   final NotificationDetails notificationDetails = NotificationDetails(
// //     android: AndroidNotificationDetails(
// //       'channel_id',
// //       'Channel Name',
// //       channelDescription: 'Description for the channel',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       ticker: 'ticker',
// //     ),
// //   );

// //   await flutterLocalNotificationsPlugin.show(
// //     message.hashCode,
// //     message.notification!.title,
// //     message.notification!.body,
// //     notificationDetails,
// //     payload: 'notifications_page', // يمكنك إرسال بيانات إضافية هنا
// //   );
// // }
// // ... بقية الكود

// دالة لإعداد الإشعارات
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // ✅ تأكد من استيراد هذه المكتبة

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }

// Future<void> setupNotifications() async {
//   // طلب صلاحيات الإشعارات (لأنظمة iOS)
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   // التعامل مع الإشعارات في الخلفية
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   // التعامل مع الإشعارات عند فتح التطبيق
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Got a message whilst in the foreground!');
//     print('Message data: ${message.data}');

//     if (message.notification != null) {
//       print('Message also contained a notification: ${message.notification}');
//       // عرض الإشعار محلياً
//       showLocalNotification(message);
//     }
//   });

//   // الحصول على token الجهاز
//   String? token = await FirebaseMessaging.instance.getToken();
//   print("FCM Token: $token");

//   saveTokenToDatabase(token);
// }

// void saveTokenToDatabase(String? token) async {
//   if (token != null) {
//     // ✅ تم تصحيح getInstance()
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     // ✅ تم تصحيح setString()
//     await prefs.setString('fcm_token', token);
//     print("FCM Token saved to SharedPreferences: $token");
//   }
// }

// void showLocalNotification(RemoteMessage message) {
//   // تنفيذ عرض إشعار محلي باستخدام awesome_notifications أو أي مكتبة أخرى
// }
