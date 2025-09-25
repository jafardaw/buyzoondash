import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/features/Order/presentation/view/order_list_view.dart';
import 'package:buyzoonapp/features/admin_setting_mang/view.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/governorates_page.dart';

import 'package:buyzoonapp/features/users/presentation/view/users_view.dart';
import 'package:buyzoonapp/product_type/presentation/view/product_type_view.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  RootViewState createState() => RootViewState();
}

class RootViewState extends State<RootView> {
  int _currentIndex = 2;

  final List<Widget> _pages = [
    OrdersView(),
    UsersScreen(),
    ProductTypesScreen(),
    GovernoratesPage(),
    AdminDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 50,
        items: <Widget>[
          Icon(Icons.shopping_bag, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.category, size: 30, color: Colors.white),
          Icon(Icons.location_city, size: 30, color: Colors.white),
          Icon(Icons.more_horiz, size: 30, color: Colors.white),
        ],
        color: Palette.primary,
        buttonBackgroundColor: Palette.secandry,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class PageWidget extends StatelessWidget {
  final String title;
  final Color color;

  const PageWidget({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.2),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
