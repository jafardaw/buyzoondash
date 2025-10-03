// lib/features/productlist/presentation/view/update_product_view.dart

import 'dart:typed_data';

import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/imagepicker/imagepicker.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/custom_button.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/productlist/data/product_list_model.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/updatecubit/update_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/updatecubit/update_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UpdateProductView extends StatelessWidget {
  const UpdateProductView({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return BodyUpdateProductview(productModel: productModel);
  }
}

class BodyUpdateProductview extends StatefulWidget {
  const BodyUpdateProductview({super.key, required this.productModel});

  final ProductModel productModel;
  @override
  State<BodyUpdateProductview> createState() => _BodyUpdateProductviewState();
}

class _BodyUpdateProductviewState extends State<BodyUpdateProductview> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController refundRateController;
  late TextEditingController profitratioController;

  late bool ban;

  // قائمة الصور الأصلية
  late List<ProductPhoto> _currentPhotos;
  // مصفوفة لتخزين معرفات الصور التي سيتم حذفها
  final List<int> _photosToDelete = [];

  List<Uint8List> _selectedImagesBytes = [];
  late double _rating;

  @override
  void initState() {
    super.initState();
    // تهيئة المتحكمات بالبيانات الموجودة في المنتج
    nameController = TextEditingController(text: widget.productModel.name);
    descriptionController = TextEditingController(
      text: widget.productModel.description,
    );
    priceController = TextEditingController(
      text: widget.productModel.price.toString(),
    );
    refundRateController = TextEditingController(
      text: widget.productModel.refundRate.toString(),
    );
    profitratioController = TextEditingController(
      text: widget.productModel.profitratio.toString(),
    );
    _rating = widget.productModel.rating;
    _currentPhotos = List.from(widget.productModel.productPhotos ?? []);
    ban = widget.productModel.ban!;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    refundRateController.dispose();
    super.dispose();
  }

  // دالة لحذف الصورة من الواجهة وإضافة معرفها إلى مصفوفة الحذف
  void _deletePhoto(ProductPhoto photo) {
    setState(() {
      _currentPhotos.removeWhere((p) => p.id == photo.id);
      _photosToDelete.add(photo.id);
      print('llllllllllllllllllllllllllllll${photo.id.toInt()}');
    });
  }

  _submitForm(BuildContext innerContext) {
    if (_formKey.currentState!.validate()) {
      if (_currentPhotos.length + _selectedImagesBytes.length < 2) {
        showCustomSnackBar(
          context,
          'يجب ان يتكون المنتج من صورتين حصراً',
          color: Palette.secandry,
        );
        return;
      }

      innerContext.read<UpdateProductCubit>().updateProduct(
        productId: widget.productModel.id,
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        rating: _rating,
        refundRate: double.parse(refundRateController.text),
        ban: ban,
        photosToDelete: _photosToDelete,
        profitratio: double.parse(profitratioController.text),
        newPhotos: _selectedImagesBytes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProductCubit, UpdateProductState>(
      listener: (context, state) {
        if (state is UpdateProductSuccess) {
          showCustomSnackBar(
            context,
            'اتم التعديل بنجاخ',
            color: Palette.success,
          );
          Navigator.pop(context, true);
        } else if (state is UpdateProductFailure) {
          showCustomSnackBar(
            context,
            'فشل التعديل ${state.errorMessage}',
            color: Palette.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const AppareWidget(
            title: 'تعديل منتج',
            automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ... (باقي الحقول كما هي) ...
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "حالة المنتج",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: !ban, // عكس القيمة
                        activeThumbColor: Colors.white,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            ban = !value;
                            print(ban);
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
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
                  CustomTextField(
                    label: const Text('نسبة الربح'),
                    hintText: 'مثال: 0.1.',
                    controller: profitratioController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال نسبة الربح';
                      }
                      final rate = double.tryParse(value);
                      if (rate == null || rate < 0 || rate > 1) {
                        return 'الرجاء إدخال نسبة بين 0 و 1';
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
                  // عرض الصور الموجودة حاليًا
                  if (_currentPhotos.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الصور الموجودة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _currentPhotos.length,
                            itemBuilder: (context, index) {
                              final photo = _currentPhotos[index];
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      photo.photoUrl,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deletePhoto(photo),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  MultiImagePickerWidget(
                    onImagesSelected: (bytesList, namesList) {
                      setState(() {
                        _selectedImagesBytes = bytesList;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  BlocBuilder<UpdateProductCubit, UpdateProductState>(
                    builder: (blocContext, state) {
                      if (state is UpdateProductLoading) {
                        return LoadingViewWidget();
                      }

                      return CustomButton(
                        onTap: () {
                          _submitForm(blocContext);
                        },
                        text: 'حفظ التعديلات',
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
