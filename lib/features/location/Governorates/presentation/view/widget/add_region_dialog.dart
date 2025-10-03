import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/add_region_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/add_region_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/region_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRegionDialog extends StatefulWidget {
  final int cityId;
  const AddRegionDialog({super.key, required this.cityId});

  @override
  State<AddRegionDialog> createState() => _AddRegionDialogState();
}

class _AddRegionDialogState extends State<AddRegionDialog> {
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
      create: (context) => AddRegionCubit(RegionRepo(ApiService())),
      child: AlertDialog(
        title: const Text('إضافة منطقة جديدة'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: Text('اسم المنطقة'),
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
                keyboardType: TextInputType.number,
                label: Text('سعر التوصيل'),
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
          BlocConsumer<AddRegionCubit, AddRegionState>(
            listener: (context, state) {
              if (state is AddRegionSuccess) {
                Navigator.pop(context, true);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('تمت الإضافة بنجاح'),
                //     backgroundColor: Colors.green,
                //   ),
                // );

                showCustomSnackBar(
                  context,
                  'تمت الإضافة بنجاح',
                  color: Palette.success,
                );
              } else if (state is AddRegionFailure) {
                showCustomSnackBar(
                  context,
                  'فشل الإضافة: ${state.error}',
                  color: Palette.error,
                );
              }
            },
            builder: (context, state) {
              if (state is AddRegionLoading) {
                return Center(child: const LoadingViewWidget());
              }
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AddRegionCubit>().addRegion(
                      name: _nameController.text,
                      cityId: widget.cityId,
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
