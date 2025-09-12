import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/util/app_router.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/auth/presentation/manger/login_cubit.dart';
import 'package:buyzoonapp/features/auth/presentation/manger/login_state.dart';
import 'package:buyzoonapp/features/auth/repo/login_repo.dart';
import 'package:buyzoonapp/features/notifaction/presentation/view/broadcast_notification_view.dart';
import 'package:buyzoonapp/features/users/presentation/view/users_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(LoginRepo(ApiService())),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoginViewBody(
          formKey: _formKey,
          usernameController: _usernameController,
          passwordController: _passwordController,
        ),
      ),
    );
  }
}

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
  }) : _formKey = formKey,
       _usernameController = usernameController,
       _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _usernameController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // إضافة صورة الشعار
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  height: 250,
                  width: 250,
                  'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // تأكد من تعديل المسار حسب موقع صورتك
                  fit: BoxFit.contain,
                ),
              ),

              const Text(
                'أهلاً بك في BuyZone',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Palette.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _usernameController,
                labelText: 'أسمك',
                hintText: 'أدخل الاسم',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.blueGrey,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء عدم  نرك حقل الاسم فارغ املأ المعلومات المناسبة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                obscureText: true,
                labelText: 'كلمة  المرور',
                hintText: 'أدخل كلمة المرور الخاصة  بك',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Palette.primary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء عدم  نرك حقل كلمة المرور فارغ املأ المعلومات المناسبة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    // AppRoutes.pushNamed(context, AppRoutes.addproducttypeview);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BroadcastNotificationScreen(),
                      ),
                    );
                    showCustomSnackBar(
                      context,
                      'تم تسجيل الدخول بنجاح',
                      color: Palette.success,
                    );
                  } else if (state is LoginFailure) {
                    showCustomSnackBar(
                      context,
                      state.error,
                      color: Palette.error,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return LoadingViewWidget();
                  }
                  if (state is LoginFailure) {
                    return ShowErrorWidgetView.inlineError(
                      errorMessage: state.error,
                      onRetry: () {
                        context.read<LoginCubit>().login(
                          usernameOrPhone: _usernameController.text,
                          password: _passwordController.text,
                        );
                      },
                    );
                  }
                  return CustomButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginCubit>().login(
                          usernameOrPhone: _usernameController.text,
                          password: _passwordController.text,
                        );
                      }
                    },
                    text: 'تسجيل',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
