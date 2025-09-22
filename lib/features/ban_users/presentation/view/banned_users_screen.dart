// lib/features/ban_users/presentation/view/banned_users_screen.dart

import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/ban_users/data/model/ban_user_model.dart';
import 'package:buyzoonapp/features/ban_users/presentation/manger/banned_users_cubit.dart';
import 'package:buyzoonapp/features/ban_users/presentation/manger/banned_users_state.dart';
import 'package:buyzoonapp/features/ban_users/presentation/view/update_ban.dart';
import 'package:buyzoonapp/features/ban_users/repo/banned_users_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannedUsersScreen extends StatelessWidget {
  const BannedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BannedUsersCubit>(
      create: (context) =>
          BannedUsersCubit(BannedUsersRepo(ApiService()))..getBannedUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المستخدمون المحظورون'),
          centerTitle: true,
        ),
        body: const BannedUsersBodyView(),
      ),
    );
  }
}

class BannedUsersBodyView extends StatelessWidget {
  const BannedUsersBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannedUsersCubit, BannedUsersState>(
      builder: (context, state) {
        if (state is BannedUsersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BannedUsersFailure) {
          return Center(child: Text('خطأ: ${state.error}'));
        } else if (state is BannedUsersSuccess) {
          if (state.users.isEmpty) {
            return const Center(
              child: Text('لا يوجد مستخدمون محظورون حاليًا.'),
            );
          }
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return _buildBannedUserCard(context, user);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBannedUserCard(BuildContext context, UserBanModel user) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.person, size: 40),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رقم الهاتف: ${user.phoneNumber}'),
            if (user.activeBan != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('سبب الحظر: ${user.activeBan!.reason}'),
                  Text(
                    'ينتهي الحظر في: ${user.activeBan!.endAt.substring(0, 10)}',
                  ),
                ],
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.lock_open, color: Colors.green),
          onPressed: () async {
            // هنا تم التعديل
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UpdateBan(userId: user.id, userBanModel: user),
              ),
            );

            // عند العودة من الصفحة، إذا كانت النتيجة true، نحدث القائمة
            if (result == true) {
              if (context.mounted) {
                context.read<BannedUsersCubit>().getBannedUsers();
              }
            }
          },
        ),
      ),
    );
  }
}
