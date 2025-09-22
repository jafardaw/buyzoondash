import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/auth/presentation/view/login_view.dart';
import 'package:buyzoonapp/features/invoice/presentation/view/invoice_view.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/governorates_page.dart';
import 'package:buyzoonapp/features/notifaction/presentation/view/broadcast_notification_view.dart';
import 'package:buyzoonapp/features/root/presentation/view/root_view.dart';
import 'package:buyzoonapp/features/splash/presentation/view/splash_screen.dart';
import 'package:buyzoonapp/features/users/presentation/view/user_details_view.dart';
import 'package:buyzoonapp/features/users/presentation/view/users_view.dart';
import 'package:buyzoonapp/product_type/presentation/view/add_product_type_view.dart';
import 'package:buyzoonapp/product_type/presentation/view/update_product_typ_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login_view';
  static const String rootView = '/root_view';

  static const String addproducttypeview = '/add_product_type_view';
  static const String updateproducttypview = '/update_product_typ_view';
  static const String usersview = '/users_view';
  static const String userdetailsview = '/user_details_view';
  static const String broadcastnotificationview =
      '/broadcast_notification_view';
  static const String governoratespage = '/governorates_page';
  static const String invoiceview = '/invoice_view';

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
        path: rootView,
        name: rootView,
        builder: (context, state) => const RootView(),
      ),
      GoRoute(
        path: addproducttypeview,
        name: addproducttypeview,
        builder: (context, state) => const AddProductTypeScreen(),
      ),
      GoRoute(
        path: updateproducttypview,
        name: updateproducttypview,
        builder: (context, state) {
          final args = state.extra as UpdateExtraArgs;

          return UpdateProductTypView(id: args.id, name: args.name);
        },
      ),
      GoRoute(
        path: usersview,
        name: usersview,
        builder: (context, state) => UsersScreen(),
      ),
      GoRoute(
        path: userdetailsview,
        name: userdetailsview,
        builder: (context, state) {
          final userId = state.extra as int;

          return UserDetailsScreen(userId: userId);
        },
      ),
      GoRoute(
        path: broadcastnotificationview,
        name: broadcastnotificationview,
        builder: (context, state) => BroadcastNotificationScreen(),
      ),
      GoRoute(
        path: governoratespage,
        name: governoratespage,
        builder: (context, state) => GovernoratesPage(),
      ),
      GoRoute(
        path: invoiceview,
        name: invoiceview,
        builder: (context, state) {
          final orderId = state.extra as int;
          return InvoiceView(orderId: orderId);
        },
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

class UpdateExtraArgs {
  final int id;
  final String name;

  UpdateExtraArgs(this.name, {required this.id});
}
