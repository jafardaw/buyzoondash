import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/ban_users/data/model/ban_user_model.dart';

import 'package:buyzoonapp/features/ban_users/presentation/manger/ban_cubit.dart';
import 'package:buyzoonapp/features/ban_users/presentation/manger/ban_state.dart';
import 'package:buyzoonapp/features/ban_users/repo/ban_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateBan extends StatelessWidget {
  final int userId;
  final UserBanModel userBanModel;

  const UpdateBan({
    super.key,
    required this.userId,
    required this.userBanModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BanCubit(BanRepo(ApiService())),
      child: Scaffold(
        appBar: AppareWidget(
          title: 'إدارة حظر المستخدم',
          automaticallyImplyLeading: false,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: UpdateBanForm(userId: userId, userBanModel: userBanModel),
        ),
      ),
    );
  }
}

class UpdateBanForm extends StatefulWidget {
  final int userId;
  final UserBanModel userBanModel;
  const UpdateBanForm({
    super.key,
    required this.userId,
    required this.userBanModel,
  });

  @override
  State<UpdateBanForm> createState() => _UpdateBanFormState();
}

class _UpdateBanFormState extends State<UpdateBanForm> {
  late final TextEditingController _reasonController;
  late final TextEditingController _daysController;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(
      text: widget.userBanModel.activeBan!.reason,
    );
    _daysController = TextEditingController(
      text: widget.userBanModel.activeBan!.bannedBy.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                controller: _reasonController,

                labelText: 'سبب الحظر',
                hintText: 'سبب الحظر',

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال سبب الحظر';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _daysController,
                keyboardType: TextInputType.number,

                labelText: 'مدة الحظر بالأيام',
                hintText: 'مدة الحظر بالأيام',
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'الرجاء إدخال عدد صحيح للأيام';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              BlocConsumer<BanCubit, BanState>(
                listener: (context, state) {
                  if (state is BanSuccess) {
                    showCustomSnackBar(
                      context,
                      state.response.message,
                      color: Palette.success,
                    );
                    Navigator.of(context).pop(true);
                  } else if (state is BanFailure) {
                    showCustomSnackBar(
                      context,
                      state.error,
                      color: Palette.error,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is BanLoading) {
                    return const LoadingViewWidget();
                  }
                  return Column(
                    children: [
                      CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<BanCubit>().updateBan(
                              userId: widget.userId,
                              reason: _reasonController.text,
                              days: int.parse(_daysController.text),
                            );
                          }
                        },
                        text: 'تعديل معلومات الحظر',
                        // لون مختلف لزر التعديل
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<BanCubit>().unBan(
                              userId: widget.userId,
                            );
                          }
                        },
                        text: ' فك الحظر',
                      ),
                    ],
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
