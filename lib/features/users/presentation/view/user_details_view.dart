import 'package:buyzoonapp/core/func/alert_dialog.dart';
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/ban_users/presentation/view/ban_page.dart';

import 'package:buyzoonapp/features/users/presentation/manger/delete_user_cubit.dart';
import 'package:buyzoonapp/features/users/presentation/manger/user_details_cubit.dart';
import 'package:buyzoonapp/features/users/presentation/manger/users_cubit.dart';
import 'package:buyzoonapp/features/users/repo/users_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsScreen extends StatelessWidget {
  final int userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserDetailsCubit>(
          create: (context) =>
              UserDetailsCubit(UsersRepo(ApiService()))
                ..getUserDetails(userId: userId),
        ),
        BlocProvider<DeleteUserCubit>(
          create: (context) => DeleteUserCubit(UsersRepo(ApiService())),
        ),
      ],
      child: Scaffold(
        appBar: const AppareWidget(
          automaticallyImplyLeading: true,
          title: 'تفاصيل المستخدم',
        ),

        body: BlocListener<DeleteUserCubit, DeleteUserState>(
          listener: (context, state) {
            if (state is DeleteUserSuccess) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.success,
              );
              Navigator.pop(
                context,
                true,
              ); // العودة للشاشة السابقة مع إشارة تحديث
            } else if (state is DeleteUserFailure) {
              showCustomSnackBar(context, state.error, color: Palette.error);
            }
          },
          child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
            builder: (context, state) {
              if (state is UserDetailsLoading) {
                return LoadingViewWidget(
                  type: LoadingType.imageShake,
                  imagePath:
                      'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
                  size: 200, // حجم الصورة
                );
              } else if (state is UserDetailsSuccess) {
                final user = state.user;
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_pin,
                              size: 100,
                              color: Palette.primary,
                            ),
                            const SizedBox(height: 20),
                            _buildDetailRow(
                              icon: Icons.person_outline,
                              label: 'اسم المستخدم:',
                              value: user.username,
                            ),
                            _buildDetailRow(
                              icon: Icons.phone_outlined,
                              label: 'رقم الهاتف:',
                              value: user.phoneNumber,
                            ),
                            _buildDetailRow(
                              icon: Icons.assignment_ind_outlined,
                              label: 'ID:',
                              value: user.id.toString(),
                            ),
                            _buildDetailRow(
                              icon: Icons.shield_outlined,
                              label: 'موظف:',
                              value: user.isStaff ? 'نعم' : 'لا',
                              color: user.isStaff ? Colors.green : Colors.red,
                            ),
                            _buildDetailRow(
                              icon: Icons.vpn_key_outlined,
                              label: 'مشرف:',
                              value: user.isSuperuser ? 'نعم' : 'لا',
                              color: user.isSuperuser
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            _buildDetailRow(
                              icon: user.isActive
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              label: 'الحالة:',
                              value: user.isActive ? 'مفعل' : 'غير مفعل',
                              color: user.isActive ? Colors.green : Colors.red,
                            ),
                            _buildDetailRow(
                              icon: Icons.access_time,
                              label: 'آخر دخول:',
                              value: user.formattedLastLogin,
                            ),
                            _buildDetailRow(
                              icon: Icons.calendar_today_outlined,
                              label: 'تاريخ الإنشاء:',
                              value: user.formattedCreatedAt,
                            ),
                            const SizedBox(height: 20),
                            // زر الحذف داخل الـ Card
                            SizedBox(
                              width: double.infinity,
                              child: BlocBuilder<DeleteUserCubit, DeleteUserState>(
                                builder: (context, deleteState) {
                                  return ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: deleteState is DeleteUserLoading
                                        ? null
                                        : () {
                                            showCustomAlertDialog(
                                              context: context,
                                              title: 'تأكيد الحذف',
                                              content:
                                                  'هل أنت متأكد من حذف المستخدم ${user.username}؟',
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('إلغاء'),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                  onPressed: () {
                                                    context
                                                        .read<DeleteUserCubit>()
                                                        .deleteUser(
                                                          userId: userId,
                                                        );
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('حذف'),
                                                ),
                                              ],
                                            );
                                          },
                                    icon: deleteState is DeleteUserLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.delete),
                                    label: Text(
                                      deleteState is DeleteUserLoading
                                          ? 'جاري الحذف...'
                                          : 'حذف المستخدم',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is UserDetailsFailure) {
                return Center(
                  child: ShowErrorWidgetView.fullScreenError(
                    onRetry: () {
                      context.read<UserDetailsCubit>().getUserDetails(
                        userId: userId,
                      );
                    },
                    errorMessage: 'خطأ في تحميل البيانات: ${state.error}',
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.grey[700]),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color ?? Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class for Error widget (assuming you have this)
