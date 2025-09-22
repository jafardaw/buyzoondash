// lib/features/location/Governorates/presentation/view/widget/add_city_dialog.dart
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/add_city_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/add_city_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/city_repo.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCityDialog extends StatefulWidget {
  final int governorateId;
  const AddCityDialog({super.key, required this.governorateId});

  @override
  State<AddCityDialog> createState() => _AddCityDialogState();
}

class _AddCityDialogState extends State<AddCityDialog> {
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
    return BlocProvider(
      create: (context) => AddCityCubit(CityRepo(ApiService())),
      child: AlertDialog(
        title: const Text('إضافة مدينة جديدة'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم المدينة'),
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
          BlocConsumer<AddCityCubit, AddCityState>(
            listener: (context, state) {
              if (state is AddCitySuccess) {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت الإضافة بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is AddCityFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل الإضافة: ${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AddCityLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AddCityCubit>().addCity(
                      governorateId: widget.governorateId,
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
