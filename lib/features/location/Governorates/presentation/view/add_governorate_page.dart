// lib/features/location/Governorates/presentation/view/add_governorate_page.dart

import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/add_governorate_cubit.dart.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/add_governorate_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddGovernoratePage extends StatelessWidget {
  const AddGovernoratePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddGovernorateCubit(GovernorateRepo(ApiService())),
      child: Scaffold(
        appBar: const AppareWidget(
          automaticallyImplyLeading: true,
          title: 'إضافة محافظة جديدة',
        ),

        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: AddGovernorateForm(),
        ),
      ),
    );
  }
}

class AddGovernorateForm extends StatefulWidget {
  const AddGovernorateForm({super.key});

  @override
  State<AddGovernorateForm> createState() => _AddGovernorateFormState();
}

class _AddGovernorateFormState extends State<AddGovernorateForm> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم المحافظة',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم المحافظة';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'سعر التوصيل',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال سعر التوصيل';
                }
                if (double.tryParse(value) == null) {
                  return 'الرجاء إدخال رقم صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            BlocConsumer<AddGovernorateCubit, AddGovernorateState>(
              listener: (context, state) {
                if (state is AddGovernorateSuccess) {
                  // إغلاق الصفحة الحالية (pop) وإرسال قيمة true
                  // هذه القيمة تُستخدم لإخبار الصفحة السابقة بضرورة التحديث
                  Navigator.of(context).pop(true);
                  // عرض رسالة النجاح
                  showCustomSnackBar(
                    context,
                    state.message,
                    color: Palette.success,
                  );
                } else if (state is AddGovernorateFailure) {
                  showCustomSnackBar(
                    context,
                    state.error,
                    color: Palette.error,
                  );
                }
              },
              builder: (context, state) {
                if (state is AddGovernorateLoading) {
                  return Center(child: const LoadingViewWidget());
                }
                return CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AddGovernorateCubit>().addGovernorate(
                        name: _nameController.text,
                        price: double.parse(_priceController.text),
                      );
                    }
                  },
                  text: 'إضافة المحافظة',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
