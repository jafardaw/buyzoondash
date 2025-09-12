import 'package:buyzoonapp/core/func/calculat_cross_axis_count.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/style/styles.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/empty_view_list.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
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
      // استخدم MultiBlocProvider
      providers: [
        BlocProvider<UsersCubit>(
          create: (context) => UsersCubit(UsersRepo(ApiService()))..getUsers(),
        ),
        BlocProvider<DeleteUserCubit>(
          // أضف الـ Cubit الخاص بالحذف
          create: (context) => DeleteUserCubit(UsersRepo(ApiService())),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'المستخدمون',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<DeleteUserCubit, DeleteUserState>(
              listener: (context, state) {
                if (state is DeleteUserSuccess) {
                  // تحديث قائمة المستخدمين تلقائياً بعد الحذف
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
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersSuccess) {
          if (state.users.isEmpty) {
            return EmptyListViews(text: 'لا يوجد مستخدمون حاليًا');
          }
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.users.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: calculateCrossAxisCount(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final user = state.users[index];
              return GestureDetector(
                onTap: () async {
                  // هنا يتم استدعاء صفحة التفاصيل
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserDetailsScreen(userId: user.id),
                    ),
                  );
                  // عند العودة من صفحة التفاصيل
                  if (result == true) {
                    // تحديث القائمة من الصفحة الأولى
                    context.read<UsersCubit>().refreshUsers();
                  }
                },
                child: UserGridItem(user: user),
              );
            },
          );
        } else if (state is UsersFailure) {
          return ShowErrorWidgetView.fullScreenError(errorMessage: state.error);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // توزيع متساوي للمساحة
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

            // رقم الهاتف
            Text(
              user.phoneNumber,
              style: Styles.textStyle18.copyWith(color: Palette.secandry),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  user.isActive ? Icons.check_circle : Icons.cancel,
                  color: user.isActive ? Palette.success : Palette.error,
                  size: 16, // حجم أيقونة أصغر
                ),
                const SizedBox(width: 4),
                Text(
                  user.isActive ? 'مفعل' : 'غير مفعل',
                  style: TextStyle(
                    color: user.isActive ? Palette.success : Palette.error,
                    fontSize: 12, // حجم خط أصغر
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
