import 'dart:typed_data';

import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/imagepicker/imagepicker.dart'; // استيراد الحزمة

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController productTypeIdController = TextEditingController();
  final TextEditingController refundRateController = TextEditingController();

  List<Uint8List> _selectedImagesBytes = [];
  List<String> _selectedImagesNames = [];
  double _rating = 0;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    productTypeIdController.dispose();
    refundRateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImagesBytes.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار صورتين على الأقل.'),
            backgroundColor: Palette.error,
          ),
        );
      } else if (_rating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء تحديد تقييم للمنتج.'),
            backgroundColor: Palette.error,
          ),
        );
      } else {
        // ... منطق إرسال البيانات
        debugPrint('Name: ${nameController.text}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إضافة المنتج بنجاح!'),
            backgroundColor: Palette.primary,
          ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: const Text('الاسم'),
                hintText: 'مثال: هاتف ذكيgdfg سامسونج',
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
              CustomTextField(
                label: const Text('معرف نوع المنتج'),
                hintText: 'مثال: 101',
                controller: productTypeIdController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال معرف النوع';
                  }
                  if (int.tryParse(value) == null) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
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
              const SizedBox(height: 8),
              CustomButton(
                onTap: () {
                  print(_rating);
                },

                text: 'حفظ المنتج',
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
