import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/style/styles.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/features/ban_users/presentation/view/banned_users_screen.dart';
import 'package:buyzoonapp/features/notifaction/presentation/view/broadcast_notification_view.dart';
import 'package:buyzoonapp/features/report/presentation/view/financial_dashboard_page.dart';
import 'package:buyzoonapp/features/users/presentation/view/users_view.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        title: 'الإعدادات و الإدارة',
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.88,
          children: [
            _buildDashboardCard(
              icon: Icons.people,
              title: 'إدارة المستخدمين',
              subtitle: ' مستخدم',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UsersScreen()),
                );
              },
            ),
            _buildDashboardCard(
              icon: Icons.block,
              title: 'المستخدمين المحظورين',
              subtitle: ' محظور',
              color: Colors.red,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BannedUsersScreen()),
              ),
            ),
            _buildDashboardCard(
              icon: Icons.analytics,
              title: 'الإحصائيات',
              subtitle: 'عرض التقارير',
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FinancialDashboardPage(),
                ),
              ),
            ),
            _buildDashboardCard(
              icon: Icons.notifications,
              title: 'الإشعارات',
              subtitle: 'إرسال اشعار لكل المستخدمين',
              color: Palette.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BroadcastNotificationScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 30, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Styles.textStyle16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Styles.textStyle14.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
