// // دالة لإعداد الإشعارات
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
