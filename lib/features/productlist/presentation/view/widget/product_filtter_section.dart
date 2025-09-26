import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/custom_field.dart';
import 'package:flutter/material.dart';

class ProductFiltersSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  // final TextEditingController descriptionController;
  // final String? status;
  final ValueChanged<String?> onStatusChanged;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final TextEditingController minStockAlertController;
  final VoidCallback onSearch;
  final VoidCallback onClearFilters;

  const ProductFiltersSection({
    super.key,
    required this.formKey,
    required this.nameController,
    // required this.descriptionController,
    // required this.status,
    required this.onStatusChanged,
    required this.minPriceController,
    required this.maxPriceController,
    required this.minStockAlertController,
    required this.onSearch,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.filter_list, color: Palette.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'فلاتر البحث',
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      initiallyExpanded: false,
      children: [
        // === هنا التعديل المهم ===
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),

          // أضف SingleChildScrollView هنا
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: nameController,
                    label: const Text('اسم المادة'),
                    prefixIcon: const Icon(Icons.label),
                  ),
                  const SizedBox(height: 12),
                  // CustomTextField(
                  //   controller: descriptionController,
                  //   label: const Text('الوصف'),
                  //   prefixIcon: const Icon(Icons.description),
                  // ),
                  const SizedBox(height: 12),
                  // DropdownButtonFormField<String>(
                  //   focusColor: Colors.white,
                  //   iconEnabledColor: Palette.primary,
                  //   iconDisabledColor: Palette.primary,
                  //   initialValue: status,
                  //   decoration: InputDecoration(
                  //     labelText: 'الحالة',
                  //     prefixIcon: const Icon(
                  //       Icons.start,
                  //       color: Palette.primary,
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //   ),
                  //   items: [
                  //     DropdownMenuItem(
                  //       value: null,
                  //       child: Text(
                  //         'الكل',
                  //         style: const TextStyle(color: Palette.primary),
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: 'used',
                  //       child: Text(
                  //         'مستخدمة',
                  //         style: const TextStyle(color: Palette.primary),
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: 'unused',
                  //       child: Text(
                  //         'غير مستخدمة',
                  //         style: const TextStyle(color: Palette.primary),
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //   ],
                  //   onChanged: onStatusChanged,
                  // ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: minPriceController,
                          keyboardType: TextInputType.number,
                          label: const Text('أقل سعر'),
                          prefixIcon: const Icon(Icons.attach_money),
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                double.tryParse(value) == null) {
                              return 'أدخل رقم صحيح';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: maxPriceController,
                          keyboardType: TextInputType.number,
                          label: const Text('أعلى سعر'),
                          prefixIcon: const Icon(Icons.attach_money),
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                double.tryParse(value) == null) {
                              return 'أدخل رقم صحيح';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: minStockAlertController,
                    keyboardType: TextInputType.number,
                    label: const Text('اقل تقييم'),
                    prefixIcon: const Icon(Icons.notifications_active),
                    validator: (value) {
                      if (value!.isNotEmpty && double.tryParse(value) == null) {
                        return 'أدخل رقم صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.search),
                          label: const Text('بحث'),
                          onPressed: onSearch,
                          style: FilledButton.styleFrom(
                            backgroundColor: Palette.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.clear, color: Palette.primary),
                          label: const Text(
                            'مسح الفلاتر',
                            style: TextStyle(color: Palette.primary),
                          ),
                          onPressed: onClearFilters,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
        // ===========================
      ],
    );
  }
}
