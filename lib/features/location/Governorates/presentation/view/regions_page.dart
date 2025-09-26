import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/city_model.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/delete_region_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/delete_region_state.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_region_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/update_region_state.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/add_region_dialog.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/location_card.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/update_region_dialog.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/region_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegionsPage extends StatefulWidget {
  final int cityId;
  final String cityName;
  const RegionsPage({super.key, required this.cityId, required this.cityName});

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage> {
  late Future<CityModel> _futureCity;

  @override
  void initState() {
    super.initState();
    _fetchCity();
  }

  Future<void> _fetchCity() async {
    setState(() {
      _futureCity = RegionRepo(ApiService()).getCityById(widget.cityId);
    });
  }

  Future<void> _deleteRegion(int regionId) async {
    try {
      await RegionRepo(ApiService()).deleteRegion(regionId: regionId);
      if (mounted) {
        _fetchCity();
        showCustomSnackBar(
          context,
          'تم حذف المنطقة بنجاح',
          color: Palette.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(
          context,
          'فشل الحذف: ${e.toString()}',
          color: Palette.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UpdateRegionCubit(RegionRepo(ApiService())),
        ),
        BlocProvider(
          create: (_) => DeleteRegionCubit(RegionRepo(ApiService())),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UpdateRegionCubit, UpdateRegionState>(
            listener: (context, state) {
              if (state is UpdateRegionSuccess) {
                _fetchCity();
              }
            },
          ),
          BlocListener<DeleteRegionCubit, DeleteRegionState>(
            listener: (context, state) {
              if (state is DeleteRegionSuccess) {
                _fetchCity();
              }
            },
          ),
        ],
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: buildFloatactionBoutton(
            context,
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => AddRegionDialog(cityId: widget.cityId),
              );
              if (result == true) {
                _fetchCity();
              }
            },
          ),
          appBar: AppareWidget(
            automaticallyImplyLeading: true,
            title: 'مناطق ${widget.cityName}',
          ),
          body: FutureBuilder<CityModel>(
            future: _futureCity,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingViewWidget(
                  type: LoadingType.imageShake,
                  imagePath:
                      'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png',
                  size: 200,
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('خطأ: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final city = snapshot.data!;
                if (city.regions.isEmpty) {
                  return const Center(
                    child: Text('لا توجد مناطق في هذه المدينة.'),
                  );
                }
                return ListView.builder(
                  itemCount: city.regions.length,
                  itemBuilder: (context, index) {
                    final region = city.regions[index];
                    return LocationCard(
                      title: region.name,
                      subtitle: 'سعر التوصيل: ${region.price}',
                      onEditPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (_) => UpdateRegionDialog(
                            region: region,
                            cityId: widget.cityId,
                          ),
                        );
                        if (result == true) {
                          _fetchCity();
                        }
                      },

                      // داخل دالة onDeletePressed:
                      onDeletePressed: () {
                        showDialog(
                          context: context,
                          // ⚠️ استخدام StatefulBuilder هنا لتحديث حالة الزر محلياً
                          builder: (dialogContext) {
                            // 1. تعريف المتغير isDeleting هنا ليبقى محتفظاً بقيمته (Closure Variable)
                            var isDeleting = false;

                            return StatefulBuilder(
                              builder: (innerDialogContext, setDialogState) {
                                return AlertDialog(
                                  title: const Text('تأكيد الحذف'),
                                  content: Text(
                                    'هل أنت متأكد من حذف منطقة ${region.name}؟', // افترض أن 'region' مُعرّف
                                  ),
                                  actions: [
                                    // زر الإلغاء
                                    TextButton(
                                      onPressed: isDeleting
                                          ? null // تعطيل الزر أثناء التحميل
                                          : () => Navigator.pop(
                                              innerDialogContext,
                                            ),
                                      child: const Text('إلغاء'),
                                    ),

                                    // زر الحذف
                                    ElevatedButton(
                                      onPressed: isDeleting
                                          ? null // تعطيل الزر أثناء التحميل
                                          : () async {
                                              // 2. بدء التحميل وتحديث حالة الـ Dialog
                                              setDialogState(
                                                () => isDeleting = true,
                                              );

                                              try {
                                                // 3. استدعاء دالة الحذف الخارجية
                                                // ⚠️ يجب تعديل دالة _deleteRegion لتكون Async وتنفذ عملية الحذف
                                                await _deleteRegion(region.id);

                                                // 4. إغلاق الدايلوج عند النجاح
                                                Navigator.pop(
                                                  // ignore: use_build_context_synchronously
                                                  innerDialogContext,
                                                );
                                              } catch (error) {
                                                // 4. إغلاق الدايلوج عند الخطأ
                                                if (innerDialogContext
                                                    .mounted) {
                                                  Navigator.pop(
                                                    innerDialogContext,
                                                  );
                                                }
                                                showCustomSnackBar(
                                                  context,
                                                  error.toString(),
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: isDeleting
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : const Text('حذف'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
