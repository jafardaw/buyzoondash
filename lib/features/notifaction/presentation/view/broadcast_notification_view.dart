import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/features/notifaction/presentation/manger/broadcast_cubit.dart';
import 'package:buyzoonapp/features/notifaction/repo/broadcast_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BroadcastNotificationScreen extends StatefulWidget {
  const BroadcastNotificationScreen({super.key});

  @override
  State<BroadcastNotificationScreen> createState() =>
      _BroadcastNotificationScreenState();
}

class _BroadcastNotificationScreenState
    extends State<BroadcastNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BroadcastCubit(BroadcastRepo(ApiService())),
      child: Scaffold(
        appBar: const AppareWidget(
          automaticallyImplyLeading: true,
          title: 'إرسال إشعار جماعي',
        ),

        body: BlocListener<BroadcastCubit, BroadcastState>(
          listener: (context, state) {
            if (state is BroadcastSuccess) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.success,
              );
              Navigator.pop(context);
            } else if (state is BroadcastFailure) {
              showCustomSnackBar(context, state.error, color: Palette.error);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // أيقونة كبيرة مع تأثير
                    const Icon(
                      Icons.notifications_active_outlined,
                      size: 100,
                      color: Palette.primary,
                    ),
                    const SizedBox(height: 20),
                    // عنوان توضيحي
                    const Text(
                      'أرسل إشعارًا لجميع المستخدمين',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Palette.secandry,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // حقل عنوان الإشعار
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: CustomTextField(
                        controller: _titleController,
                        labelText: 'عنوان الإشعار',
                        hintText: 'أدخل عنوان الإشعار هنا',
                        prefixIcon: const Icon(
                          Icons.title,
                          color: Palette.secandry,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال عنوان الإشعار';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // حقل محتوى الإشعار
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: CustomTextField(
                        controller: _bodyController,
                        labelText: 'محتوى الإشعار',
                        hintText: 'أدخل محتوى الإشعار هنا',
                        prefixIcon: const Icon(
                          Icons.description,
                          color: Palette.secandry,
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال محتوى الإشعار';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    // زر الإرسال
                    BlocBuilder<BroadcastCubit, BroadcastState>(
                      builder: (context, state) {
                        if (state is BroadcastLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<BroadcastCubit>().sendNotification(
                                title: _titleController.text,
                                body: _bodyController.text,
                              );
                            }
                          },
                          text: 'إرسال الإشعار',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
