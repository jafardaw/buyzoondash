import 'package:buyzoonapp/features/auth/presentation/view/login_view.dart';
import 'package:buyzoonapp/features/splash/presentation/view/splash_screen.dart';
import 'package:buyzoonapp/product_type/presentation/view/add_product_type_view.dart';
import 'package:buyzoonapp/product_type/presentation/view/product_type_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  // Route paths
  static const String splash = '/';
  static const String login = '/login_view';
  static const String rootView = '/root_view';

  static const String addproducttypeview = '/add_product_type_view';
  static const String updateproducttypview = '/update_product_typ_view';

  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        name: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: addproducttypeview,
        name: addproducttypeview,
        builder: (context, state) => const AddProductTypeScreen(),
      ),
      GoRoute(
        path: updateproducttypview,
        name: updateproducttypview,
        builder: (context, state) => const AddProductTypeScreen(),
      ),
    ],
  );

  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    GoRouter.of(context).pushNamed(routeName, extra: extra);
  }

  static void goNamed(BuildContext context, String routeName, {Object? extra}) {
    GoRouter.of(context).goNamed(routeName, extra: extra);
  }
}
