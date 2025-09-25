// lib/features/location/Governorates/presentation/view/cities_page.dart

// ... (existing imports)
import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/regions_page.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/add_city_dialog.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/location_card.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/update_city_dialog.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/city_repo.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/city_model.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/governorate_model.dart';
import 'package:flutter/material.dart';

class CitiesPage extends StatefulWidget {
  final int governorateId;
  final String governorateName;
  const CitiesPage({
    super.key,
    required this.governorateId,
    required this.governorateName,
  });

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  late Future<GovernorateModel> _futureGovernorate;

  @override
  void initState() {
    super.initState();
    _fetchGovernorate();
  }

  Future<void> _fetchGovernorate() async {
    setState(() {
      _futureGovernorate = CityRepo(
        ApiService(),
      ).getGovernorateById(widget.governorateId);
    });
  }

  Future<void> _deleteCity(CityModel city) async {
    try {
      await CityRepo(ApiService()).deleteCity(cityId: city.id);
      _fetchGovernorate(); // تحديث القائمة بعد الحذف

      showCustomSnackBar(context, ' تم الحذف بنجاح', color: Palette.success);
    } catch (e) {
      showCustomSnackBar(context, 'فشل الحذف: $e', color: Palette.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: buildFloatactionBoutton(
        context,
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => AddCityDialog(governorateId: widget.governorateId),
          );
          if (result == true) {
            _fetchGovernorate();
          }
        },
      ),
      appBar: AppareWidget(
        automaticallyImplyLeading: true,
        title: 'مدن ${widget.governorateName}',
      ),
      // appBar: AppBar(
      //   title: Text('مدن ${widget.governorateName}'),
      // centerTitle: true,
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.add_circle_outline),
      //     onPressed: () async {
      //       final result = await showDialog(
      //         context: context,
      //         builder: (_) =>
      //             AddCityDialog(governorateId: widget.governorateId),
      //       );
      //       if (result == true) {
      //         _fetchGovernorate();
      //       }
      //     },
      //   ),
      // ],
      // ),
      body: FutureBuilder<GovernorateModel>(
        future: _futureGovernorate,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingViewWidget(
              type: LoadingType.imageShake,
              imagePath:
                  'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
              size: 200, // حجم الصورة
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final governorate = snapshot.data!;
            if (governorate.cities.isEmpty) {
              return const Center(child: Text('لا توجد مدن في هذه المحافظة.'));
            }
            return ListView.builder(
              itemCount: governorate.cities.length,
              itemBuilder: (context, index) {
                final city = governorate.cities[index];
                return LocationCard(
                  title: city.name,
                  subtitle: 'سعر التوصيل: ${city.price}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RegionsPage(cityId: city.id, cityName: city.name),
                      ),
                    );
                  },
                  onEditPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => UpdateCityDialog(city: city),
                    );
                    if (result == true) {
                      _fetchGovernorate();
                    }
                  },
                  onDeletePressed: () async {
                    final result = showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: Text(
                          'هل أنت متأكد أنك تريد حذف مدينة ${city.name}؟',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteCity(city);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('حذف'),
                          ),
                        ],
                      ),
                    );
                  },
                  // onAddPressed: () async {
                  //   final result = await showDialog(
                  //     context: context,
                  //     builder: (_) =>
                  //         AddCityDialog(governorateId: widget.governorateId),
                  //   );
                  //   if (result == true) {
                  //     _fetchGovernorate();
                  //   }
                  // }, // الزر أصبح في الـ AppBar
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
