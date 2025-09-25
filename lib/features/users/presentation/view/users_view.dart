import 'package:buyzoonapp/core/func/calculat_cross_axis_count.dart';
import 'package:buyzoonapp/core/func/show_menu.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/style/styles.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/empty_view_list.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/ban_users/presentation/view/ban_page.dart';
import 'package:buyzoonapp/features/notifaction/presentation/view/broadcast_notification_view.dart';
import 'package:buyzoonapp/features/users/data/model/user_model.dart';
import 'package:buyzoonapp/features/users/presentation/manger/delete_user_cubit.dart';
import 'package:buyzoonapp/features/users/presentation/manger/users_cubit.dart';
import 'package:buyzoonapp/features/users/presentation/view/user_details_view.dart';
import 'package:buyzoonapp/features/users/repo/users_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UsersCubit>(
          create: (context) => UsersCubit(UsersRepo(ApiService()))..getUsers(),
        ),
        BlocProvider<DeleteUserCubit>(
          create: (context) => DeleteUserCubit(UsersRepo(ApiService())),
        ),
      ],
      child: Scaffold(
        appBar: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'المستخدمون',
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BroadcastNotificationScreen(),
                  ),
                );
              },
              icon: Icon(Icons.notifications),
            ),
          ],
        ),

        body: MultiBlocListener(
          listeners: [
            BlocListener<DeleteUserCubit, DeleteUserState>(
              listener: (context, state) {
                if (state is DeleteUserSuccess) {
                  context.read<UsersCubit>().refreshUsers();
                }
              },
            ),
          ],
          child: const UsersBodyView(),
        ),
      ),
    );
  }
}

class UsersBodyView extends StatefulWidget {
  const UsersBodyView({super.key});

  @override
  State<UsersBodyView> createState() => _UsersBodyViewState();
}

class _UsersBodyViewState extends State<UsersBodyView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UsersCubit>().getUsers();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersState>(
      listener: (context, state) {
        // لا حاجة لـ listener هنا، سنستخدم MultiBlocListener في طبقة أعلى
      },
      builder: (context, state) {
        if (state is UsersLoading) {
          return const LoadingViewWidget(
            type: LoadingType.imageShake,
            imagePath:
                'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
            size: 200, // حجم الصورة
          );
        } else if (state is UsersSuccess) {
          if (state.users.isEmpty) {
            return EmptyListViews(text: 'لا يوجد مستخدمون حاليًا');
          }
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.users.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: calculateCrossAxisCountuser(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final user = state.users[index];
              return GestureDetector(
                onTapDown: (details) {
                  showProductMenu(
                    context: context,
                    position: details.globalPosition,
                    menuItems: [
                      {
                        'value': 'view',
                        'icon': const Icon(
                          Icons.person_pin,
                          color: Palette.secandry,
                        ),
                        'title': 'تفاصيل المستخدم',
                        'onTap': () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserDetailsScreen(userId: user.id),
                            ),
                          );
                          // عند العودة من صفحة التفاصيل
                          if (result == true) {
                            // تحديث القائمة من الصفحة الأولى
                            context.read<UsersCubit>().refreshUsers();
                          }
                        },
                      },
                      {
                        'value': 'ban',
                        'icon': const Icon(Icons.block, color: Colors.red),
                        'title': 'حظر او فك الحظر',
                        'onTap': () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BanPage(userId: user.id),
                            ),
                          );
                          if (result == true) {
                            if (context.mounted) {
                              context.read<UsersCubit>().refreshUsers();
                            }
                          }
                        },
                      },
                    ],
                  );
                },
                child: UserGridItem(user: user),
              );
            },
          );
        } else if (state is UsersFailure) {
          return ShowErrorWidgetView.fullScreenError(
            errorMessage: state.error,
            onRetry: () {
              context.read<UsersCubit>().getUsers();
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}

class UserGridItem extends StatelessWidget {
  final UserModel user;

  const UserGridItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person_pin, size: 65, color: Palette.primary),
              const SizedBox(height: 8),
              Text(
                user.username,
                textAlign: TextAlign.center,
                style: Styles.textStyle18,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                user.phoneNumber,
                style: Styles.textStyle18.copyWith(color: Palette.secandry),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    user.isActive ? Icons.check_circle : Icons.cancel,
                    color: user.isActive ? Palette.success : Palette.error,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.isActive ? 'مفعل' : 'غير مفعل',
                    style: TextStyle(
                      color: user.isActive ? Palette.success : Palette.error,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              // IconButton(
              //   onPressed: () async {
              //     final result = await Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => BanPage(userId: user.id),
              //       ),
              //     );
              //     // عند العودة بنجاح، يتم تحديث القائمة
              //     if (result == true) {
              //       if (context.mounted) {
              //         context.read<UsersCubit>().refreshUsers();
              //       }
              //     }
              //   },
              //   icon: const Icon(Icons.block, color: Colors.red),
              //   tooltip: 'حظر او فك حظر المستخدم',
              // ), // Spacer لإعطاء مساحة بين المعلومات والأزرار
            ],
          ),
        ),
      ),
    );
  }
}
