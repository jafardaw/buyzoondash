// lib/features/product_types/ui/add_product_type_screen.dart

import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dio/dio.dart';

class AddProductTypeScreen extends StatefulWidget {
  const AddProductTypeScreen({super.key});

  @override
  State<AddProductTypeScreen> createState() => _AddProductTypeScreenState();
}

class _AddProductTypeScreenState extends State<AddProductTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductTypeCubit(ProductTypeRepo(ApiService(Dio()))),
      child: Scaffold(
        appBar: AppBar(title: const Text('إضافة نوع منتج')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<ProductTypeCubit, ProductTypeState>(
            listener: (context, state) {
              if (state is AddProductTypeLoading) {
                showCustomSnackBar(
                  context,
                  'جاري الإضافة...',
                  color: Palette.secandry,
                );
              } else if (state is AddProductTypeSuccess) {
                showCustomSnackBar(
                  context,
                  'تمت الإضافة بنجاح!',
                  color: Palette.success,
                );

                _nameController.clear();
              } else if (state is AddProductTypeFailure) {
                showCustomSnackBar(
                  context,
                  'فشل product type: ${state.error}',
                  color: Palette.success,
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,

                    labelText: 'اسم نوع المنتج',

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم نوع المنتج';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ProductTypeCubit, ProductTypeState>(
                    builder: (context, state) {
                      if (state is AddProductTypeLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProductTypeCubit>().addProductType(
                              name: _nameController.text,
                            );
                          }
                        },
                        child: const Text('إضافة'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
