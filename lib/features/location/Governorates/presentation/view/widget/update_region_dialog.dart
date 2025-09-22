import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/region_model.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_region_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_region_state.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/region_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateRegionDialog extends StatefulWidget {
  final RegionModel region;
  final int cityId;
  const UpdateRegionDialog({
    super.key,
    required this.region,
    required this.cityId,
  });

  @override
  State<UpdateRegionDialog> createState() => _UpdateRegionDialogState();
}

class _UpdateRegionDialogState extends State<UpdateRegionDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.region.name);
    _priceController = TextEditingController(text: widget.region.price);
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
      create: (context) => UpdateRegionCubit(RegionRepo(ApiService())),
      child: AlertDialog(
        title: const Text('تعديل المنطقة'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم المنطقة'),
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
          BlocConsumer<UpdateRegionCubit, UpdateRegionState>(
            listener: (context, state) {
              if (state is UpdateRegionSuccess) {
                showCustomSnackBar(
                  context,
                  state.message,
                  color: Palette.success,
                );
                Navigator.pop(context, true);
              } else if (state is UpdateRegionFailure) {
                showCustomSnackBar(context, state.error, color: Palette.error);
              }
            },
            builder: (context, state) {
              if (state is UpdateRegionLoading) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<UpdateRegionCubit>().updateRegion(
                      regionId: widget.region.id,
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
