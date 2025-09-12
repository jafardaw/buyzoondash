import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/util/app_router.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/get_cubit/get_all_poduct_cubit.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:buyzoonapp/firebase_options.dart';
import 'package:buyzoonapp/notifaction_local.dart';
import 'package:buyzoonapp/product_type/presentation/manger/add_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/delete_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/update_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeLocalNotifications();

  await setupNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsCubit>(
          create: (context) =>
              ProductsCubit(AddProductRepository(ApiService())),
        ),
        BlocProvider<AddProductCubit>(
          create: (context) =>
              AddProductCubit(AddProductRepository(ApiService())),
        ),
        BlocProvider<GetProductTypeCubit>(
          create: (context) =>
              GetProductTypeCubit(ProductTypeRepo(ApiService()))
                ..getProductTypes(),
        ),
        BlocProvider<DeleteProductTypeCubit>(
          create: (context) =>
              DeleteProductTypeCubit(ProductTypeRepo(ApiService())),
        ),
        // Add AddProductTypeCubit and UpdateProductTypeCubit here to make them available
        BlocProvider<AddProductTypeCubit>(
          create: (context) =>
              AddProductTypeCubit(ProductTypeRepo(ApiService())),
        ),
        BlocProvider<UpdateProductTypeCubit>(
          create: (context) =>
              UpdateProductTypeCubit(ProductTypeRepo(ApiService())),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Splash Screen Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar'), // دعم اللغة العربية
          Locale('en'), // دعم اللغة الإنجليزية
        ],
        locale: const Locale('ar'),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}



// import 'package:buyzoonapp/core/util/app_router.dart';
// import 'package:buyzoonapp/firebase_options.dart';
// import 'package:buyzoonapp/notifications_setup.dart'; // تأكد من الاسم
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// // دالة لمعالجة النقر على الإشعار
// void handleNotificationTap(RemoteMessage message) {
//   // هنا يتم توجيه المستخدم إلى صفحة الإشعارات
//   // يجب أن يكون لديك مسار (path) لهذه الصفحة في ملف app_router.dart
//   AppRoutes.router.go('/notifications');
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await initializeLocalNotifications();
//   await setupNotifications();
  
//   // الاستماع للنقر على الإشعار عندما يكون التطبيق في الخلفية أو مغلقاً
//   FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationTap);

//   // التعامل مع الحالة التي يفتح فيها التطبيق بسبب النقر على إشعار
//   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//   if (initialMessage != null) {
//     handleNotificationTap(initialMessage);
//   }

//   runApp(const MyApp());
// }

// // ... بقية الكود