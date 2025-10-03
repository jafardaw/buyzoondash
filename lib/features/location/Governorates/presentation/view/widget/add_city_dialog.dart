// lib/features/location/Governorates/presentation/view/widget/add_city_dialog.dart
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
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
              CustomTextField(
                controller: _nameController,
                label: Text('اسم المديبنة'),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              CustomTextField(
                controller: _priceController,
                label: Text('سعر التوصيل'),

                keyboardType: TextInputType.number,

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

                showCustomSnackBar(
                  context,
                  'تمت الإضافة بنجاح',
                  color: Palette.success,
                );
              } else if (state is AddCityFailure) {
                showCustomSnackBar(
                  context,
                  'فشل الإضافة: ${state.error}',
                  color: Palette.error,
                );
              }
            },
            builder: (context, state) {
              if (state is AddCityLoading) {
                return Center(child: const LoadingViewWidget());
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
