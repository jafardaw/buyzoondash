import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';

import 'package:buyzoonapp/features/ban_users/presentation/manger/ban_cubit.dart';
import 'package:buyzoonapp/features/ban_users/presentation/manger/ban_state.dart';
import 'package:buyzoonapp/features/ban_users/repo/ban_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BanPage extends StatelessWidget {
  final int userId;
  const BanPage({super.key, required this.userId});

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
          child: BanForm(userId: userId),
        ),
      ),
    );
  }
}

class BanForm extends StatefulWidget {
  final int userId;
  const BanForm({super.key, required this.userId});

  @override
  State<BanForm> createState() => _BanFormState();
}

class _BanFormState extends State<BanForm> {
  final _reasonController = TextEditingController();
  final _daysController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    _daysController.dispose();
    super.dispose();
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
                return Column(
                  children: [
                    CustomButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<BanCubit>().banUser(
                            userId: widget.userId,
                            reason: _reasonController.text,
                            days: int.parse(_daysController.text),
                          );
                        }
                      },
                      text: 'حظر المستخدم',
                    ),

                    const SizedBox(height: 10),
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
                      text: 'تعديل الحظر',
                      // لون مختلف لزر التعديل
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
