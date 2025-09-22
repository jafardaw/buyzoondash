import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/governorate_model.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_governorate_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_governorate_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateGovernorateDialog extends StatefulWidget {
  final GovernorateModel governorate;
  const UpdateGovernorateDialog({super.key, required this.governorate});

  @override
  State<UpdateGovernorateDialog> createState() =>
      _UpdateGovernorateDialogState();
}

class _UpdateGovernorateDialogState extends State<UpdateGovernorateDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.governorate.name);
    _priceController = TextEditingController(text: widget.governorate.price);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateGovernorateCubit(GovernorateRepo(ApiService())),
      child: AlertDialog(
        title: const Text('تعديل المحافظة'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم المحافظة'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'سعر التوصيل'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'الرجاء إدخال سعر صحيح';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          BlocConsumer<UpdateGovernorateCubit, UpdateGovernorateState>(
            listener: (context, state) {
              if (state is UpdateGovernorateSuccess) {
                // إغلاق الـ Dialog
                Navigator.pop(context, true); // إرسال true كإشارة للنجاح
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم التعديل بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is UpdateGovernorateFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل التعديل: ${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UpdateGovernorateLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<UpdateGovernorateCubit>().updateGovernorate(
                      id: widget.governorate.id,
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                    );
                  }
                },
                child: const Text('حفظ'),
              );
            },
          ),
        ],
      ),
    );
  }
}
