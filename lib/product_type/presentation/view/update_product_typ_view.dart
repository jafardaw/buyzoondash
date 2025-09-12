import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/update_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:buyzoonapp/core/util/api_service.dart';

class UpdateProductTypView extends StatefulWidget {
  final int id;
  final String name;
  const UpdateProductTypView({super.key, required this.id, required this.name});

  @override
  State<UpdateProductTypView> createState() => _UpdateProductTypeScreenState();
}

class _UpdateProductTypeScreenState extends State<UpdateProductTypView> {
  final _formKey = GlobalKey<FormState>();
  // final _nameController = TextEditingController(text: widget.name);
  late TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UpdateProductTypeCubit(ProductTypeRepo(ApiService())),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تعديل نوع منتج',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocListener<UpdateProductTypeCubit, UpdateProductTypeState>(
          listener: (context, state) {
            if (state is UpdateProductTypeLoading) {
              showCustomSnackBar(
                context,
                'جاري الإضافة...',
                color: Palette.secandry,
              );
            } else if (state is UpdateProductTypeSuccess) {
              showCustomSnackBar(
                context,
                'تمت الإضافة بنجاح!',
                color: Palette.success,
              );
              nameController.clear();
            } else if (state is UpdateProductTypeFailure) {
              showCustomSnackBar(
                context,
                'فشل إضافة نوع المنتج: ${state.error}',
                color: Palette.error,
              );
            }
          },
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
                            color: Colors.white.withValues(alpha: 0.7),
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
                      color: Colors.white.withValues(alpha: 0.9),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: CustomTextField(
                          controller: nameController,
                          labelText: 'اسم نوع المنتج',
                          hintText: 'ادخل اسم النوع هنا',
                          labelStyle: TextStyle(color: Colors.deepPurple[700]),
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
                    BlocBuilder<UpdateProductTypeCubit, UpdateProductTypeState>(
                      builder: (context, state) {
                        if (state is UpdateProductTypeLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<UpdateProductTypeCubit>()
                                  .updateProductType(
                                    id: widget.id,
                                    name: nameController.text,
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
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void clearForm() {
    nameController.dispose();
  }
}
