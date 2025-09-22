import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/features/ban_users/presentation/view/banned_users_screen.dart';
import 'package:buyzoonapp/features/invoice/presentation/view/invoice_view.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/governorates_page.dart';
import 'package:buyzoonapp/features/notifaction/presentation/view/broadcast_notification_view.dart';
import 'package:buyzoonapp/features/report/presentation/view/financial_dashboard_page.dart';
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
  int _currentIndex = 0;

  final List<Widget> _pages = [
    GovernoratesPage(),
    BannedUsersScreen(),
    UsersScreen(),
    ProductTypesScreen(),
    InvoiceView(orderId: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.lock, size: 30, color: Colors.white),
          Icon(Icons.person_2, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
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
