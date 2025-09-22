import 'package:buyzoonapp/core/util/api_service.dart';
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
          BlocConsumer<AddRegionCubit, AddRegionState>(
            listener: (context, state) {
              if (state is AddRegionSuccess) {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت الإضافة بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is AddRegionFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل الإضافة: ${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AddRegionLoading) {
                return const CircularProgressIndicator();
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
