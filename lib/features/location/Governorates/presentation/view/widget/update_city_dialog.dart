// lib/features/location/Governorates/presentation/view/widget/update_city_dialog.dart

import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/city_model.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_city_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_city_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/city_repo.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCityDialog extends StatefulWidget {
  final CityModel city;
  const UpdateCityDialog({super.key, required this.city});

  @override
  State<UpdateCityDialog> createState() => _UpdateCityDialogState();
}

class _UpdateCityDialogState extends State<UpdateCityDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.city.name);
    _priceController = TextEditingController(text: widget.city.price);
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
      create: (context) => UpdateCityCubit(CityRepo(ApiService())),
      child: AlertDialog(
        title: const Text('تعديل المدينة'),
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
          BlocConsumer<UpdateCityCubit, UpdateCityState>(
            listener: (context, state) {
              if (state is UpdateCitySuccess) {
                Navigator.pop(context, true);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('تم التعديل بنجاح'),
                //     backgroundColor: Colors.green,
                //   ),
                // );
                showCustomSnackBar(
                  context,
                  'تم التعديل بنجاح',
                  color: Palette.success,
                );
              } else if (state is UpdateCityFailure) {
                showCustomSnackBar(
                  context,
                  'فشل التعديل: ${state.error}',
                  color: Palette.error,
                );
              }
            },
            builder: (context, state) {
              if (state is UpdateCityLoading) {
                return Center(child: const LoadingViewWidget());
              }
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<UpdateCityCubit>().updateCity(
                      cityId: widget.city.id,
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
