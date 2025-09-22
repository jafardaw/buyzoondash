import 'dart:typed_data';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiImagePickerWidget extends StatefulWidget {
  // Callback لإرجاع قائمة بالصور المختارة
  final Function(List<Uint8List> bytes, List<String> fileNames)
  onImagesSelected;
  final List<String>?
  initialImageUrls; // لعرض الصور القادمة من السيرفر عند التعديل

  const MultiImagePickerWidget({
    super.key,
    required this.onImagesSelected,
    this.initialImageUrls,
  });

  @override
  State<MultiImagePickerWidget> createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  // الحالة المحلية الآن أصبحت قوائم لتخزين عدة صور
  final List<Uint8List> _selectedImagesBytes = [];
  final List<String> _selectedImagesNames = [];

  // دالة لاختيار عدة صور
  Future<void> _pickImages() async {
    // استخدم pickMultiImage لاختيار عدة صور
    final List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      List<Uint8List> tempBytes = [];
      List<String> tempNames = [];

      for (var file in pickedFiles) {
        tempBytes.add(await file.readAsBytes());
        tempNames.add(file.name);
      }

      setState(() {
        // أضف الصور الجديدة إلى القائمة الحالية
        _selectedImagesBytes.addAll(tempBytes);
        _selectedImagesNames.addAll(tempNames);
      });

      // أرسل القائمة المحدثة كاملةً
      widget.onImagesSelected(_selectedImagesBytes, _selectedImagesNames);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImagesBytes.removeAt(index);
      _selectedImagesNames.removeAt(index);
    });
    // أرسل القائمة المحدثة كاملةً
    widget.onImagesSelected(_selectedImagesBytes, _selectedImagesNames);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: GridView.builder(
        shrinkWrap: true, // ضروري لوضع GridView داخل Column
        physics:
            const NeverScrollableScrollPhysics(), // لمنع التمرير داخل GridView
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // عدد الصور في كل صف
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        // عدد العناصر هو عدد الصور + 1 (لزر الإضافة)
        itemCount: _selectedImagesBytes.length + 1,
        itemBuilder: (context, index) {
          // إذا كان هذا هو العنصر الأخير، اعرض زر الإضافة
          if (index == _selectedImagesBytes.length) {
            return _buildAddButton();
          } //

          // وإلا، اعرض الصورة المختارة
          return _buildImageTile(_selectedImagesBytes[index], index);
        },
      ),
    );
  }

  // Widget لعرض الصورة مع زر حذف
  Widget _buildImageTile(Uint8List imageBytes, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: MemoryImage(imageBytes),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.red, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  // Widget لزر إضافة الصور
  Widget _buildAddButton() {
    return InkWell(
      onTap: _pickImages,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade400,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade600),
              const SizedBox(height: 4),
              Text(
                "إضافة صور",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyMultiImageFormPage extends StatefulWidget {
  const MyMultiImageFormPage({super.key});

  @override
  _MyMultiImageFormPageState createState() => _MyMultiImageFormPageState();
}

class _MyMultiImageFormPageState extends State<MyMultiImageFormPage> {
  // استخدم قوائم لتخزين بيانات الصور التي يتم إرجاعها من الـ Widget
  List<Uint8List> _finalImagesBytes = [];
  List<String> _finalImagesNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor, // استخدام لون الخلفية الجديد

      appBar: AppBar(title: Text("اختيار عدة صور")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("صور الإعلان", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            MultiImagePickerWidget(
              onImagesSelected: (bytesList, namesList) {
                // عندما يختار المستخدم الصور، يتم تحديث الحالة هنا
                setState(() {
                  _finalImagesBytes = bytesList;
                  _finalImagesNames = namesList;
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // هنا، _finalImagesBytes هي القائمة التي سترسلها للـ API
                  if (_finalImagesBytes.isNotEmpty) {
                    print("تم اختيار ${_finalImagesBytes.length} صورة.");
                    print("أسماء الملفات: $_finalImagesNames");
                    // ... أضف هنا كود الرفع إلى الـ API
                  } else {
                    print("لم يتم اختيار أي صورة.");
                  }
                },
                child: const Text("حفظ الإعلان"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
