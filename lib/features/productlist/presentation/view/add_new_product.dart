// lib/features/add_product/add_new_product.dart

import 'dart:typed_data';
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_state.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/imagepicker/imagepicker.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key, required this.id});
  final int id;

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController refundRateController = TextEditingController();
  final TextEditingController productTypeIdController =
      TextEditingController(); // Added back

  List<Uint8List> _selectedImagesBytes = [];
  List<String> _selectedImagesNames = [];
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    productTypeIdController.text = widget.id.toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    productTypeIdController.dispose();
    refundRateController.dispose();
    super.dispose();
  }

  _submitForm(BuildContext innerContext) {
    if (_formKey.currentState!.validate()) {
      if (_selectedImagesBytes.length < 2) {
        showCustomSnackBar(
          context,
          'الرجاء اختيار صورتين على الأقل.',
          color: Palette.secandry,
        );
      } else if (_rating == 0) {
        showCustomSnackBar(
          context,
          'الرجاء تحديد تقييم للمنتج',
          color: Palette.secandry,
        );
      } else {
        innerContext.read<AddProductCubit>().addNewProduct(
          name: nameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          rating: _rating,
          productTypeId: widget.id,
          refundRate: double.parse(refundRateController.text),
          imagesBytes: _selectedImagesBytes,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppareWidget(
        automaticallyImplyLeading: true,
        title: 'إضافة منتج جديد',
      ),
      body: BlocListener<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state is AddProductSuccess) {
            showCustomSnackBar(
              context,
              'تم إضافة المنتج بنجاح',
              color: Palette.success,
            );

            Navigator.pop(context, true);
          } else if (state is AddProductFailure) {
            showCustomSnackBar(
              context,
              state.errorMessage,
              color: Palette.error,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  label: const Text('الاسم'),
                  hintText: 'مثال: هاتف ذكي سامسونج',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المنتج';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: const Text('الوصف'),
                  hintText: 'وصف مفصل عن المنتج',
                  controller: descriptionController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الوصف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: const Text('السعر'),
                  hintText: 'مثال: 1200.50',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال السعر';
                    }
                    if (double.tryParse(value) == null) {
                      return 'الرجاء إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'التقييم (من 1 إلى 5)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 32.0,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),

                const SizedBox(height: 24),
                CustomTextField(
                  label: const Text('نسبة الاسترجاع'),
                  hintText: 'مثال: 15.0',
                  controller: refundRateController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال نسبة الاسترجاع';
                    }
                    final rate = double.tryParse(value);
                    if (rate == null || rate < 0 || rate > 100) {
                      return 'الرجاء إدخال نسبة بين 0 و 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                MultiImagePickerWidget(
                  onImagesSelected: (bytesList, namesList) {
                    setState(() {
                      _selectedImagesBytes = bytesList;
                      _selectedImagesNames = namesList;
                    });
                  },
                ),
                const SizedBox(height: 14),
                // هنا يتم التعديل على الزر
                BlocBuilder<AddProductCubit, AddProductState>(
                  builder: (blocContext, state) {
                    // bool isLoading = state is AddProductLoading;

                    // if (isLoading) {
                    //   return Center(child: const LoadingViewWidget());
                    // }
                    if (state is AddProductLoading) {
                      return Center(child: const LoadingViewWidget());
                    }

                    return CustomButton(
                      onTap: () {
                        _submitForm(blocContext);
                      },
                      text: 'حفظ المنتج',
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
