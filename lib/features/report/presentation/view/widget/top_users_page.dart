import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/empty_view_list.dart';
import 'package:buyzoonapp/features/report/data/model/top_report_users_model.dart';
import 'package:flutter/material.dart';

class TopUsersPage extends StatelessWidget {
  final List<TopReportUsersModel> users;
  const TopUsersPage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        title: 'أفضل المستخدمين',
        automaticallyImplyLeading: false,
      ),

      body: users.isEmpty
          ? const EmptyListViews(text: 'لا يوجد مستخدمون في هذا التقرير.')
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 40),
                    title: Text(
                      user.user.username ?? 'مستخدم غير معروف',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('عدد الطلبات: ${user.ordersCount}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('إجمالي الإنفاق'),
                        Text(
                          user.totalSpent.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
