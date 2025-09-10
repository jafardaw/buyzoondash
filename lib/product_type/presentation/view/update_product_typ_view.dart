import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:buyzoonapp/core/util/api_service.dart';

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
        appBar: AppBar(
          title: const Text(
            'إضافة نوع منتج',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocListener<ProductTypeCubit, ProductTypeState>(
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
                'فشل إضافة نوع المنتج: ${state.error}',
                color: Palette.error,
              );
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الصورة
                      ClipRRect(
                        child: Image.asset(
                          height: 250,
                          width: 250,
                          'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png',
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.add_circle,
                              size: 80,
                              color: Colors.white.withOpacity(0.7),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // حقل الإدخال
                      Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: CustomTextField(
                            controller: _nameController,
                            labelText: 'اسم نوع المنتج',
                            hintText: 'ادخل اسم النوع هنا',
                            labelStyle: TextStyle(
                              color: Colors.deepPurple[700],
                            ),
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(
                              Icons.category,
                              color: Palette.secandry,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال اسم نوع المنتج';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      // زر الإضافة
                      BlocBuilder<ProductTypeCubit, ProductTypeState>(
                        builder: (context, state) {
                          if (state is AddProductTypeLoading) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          return CustomButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ProductTypeCubit>().addProductType(
                                  name: _nameController.text,
                                );
                              }
                            },
                            text: 'إضافة',
                          );
                        },
                      ),
                    ],
                  ),
                ),
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
