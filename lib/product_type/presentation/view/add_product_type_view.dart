import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Palette.backgroundColor),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // صورة رمزية
                      ClipOval(
                        child: Image.asset(
                          height: 250,
                          width: 250,
                          'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.category,
                              size: 70,
                              color: Colors.white.withValues(alpha: 0.8),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      // حقل إدخال الاسم
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white.withValues(alpha: 0.95),
                        shadowColor: Colors.deepPurple.withValues(alpha: 0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: CustomTextField(
                            controller: _nameController,
                            labelText: 'اسم نوع المنتج',
                            hintText: 'أدخل اسم نوع المنتج هنا',
                            labelStyle: TextStyle(
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.category_rounded,
                              color: Palette.secandry,
                              size: 24,
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 3,
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
                            text: 'إضافة نوع المنتج',
                          );
                        },
                      ),
                      const SizedBox(height: 20),
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
