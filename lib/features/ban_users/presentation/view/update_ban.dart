import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
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
        appBar: AppBar(
          title: const Text('إدارة حظر المستخدم'),
          centerTitle: true,
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'سبب الحظر',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال سبب الحظر';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'مدة الحظر بالأيام',
                border: OutlineInputBorder(),
              ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.response.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop(true);
                } else if (state is BanFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is BanLoading) {
                  return const CircularProgressIndicator();
                }
                return CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<BanCubit>().updateBan(
                        userId: widget.userId,
                        reason: _reasonController.text,
                        days: int.parse(_daysController.text),
                      );
                    }
                  },
                  text: 'تعديل الحظر',
                  // لون مختلف لزر التعديل
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
