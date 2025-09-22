import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/city_model.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/add_region_dialog.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/location_card.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/region_repo.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add_circle_outline),
        //     onPressed: () async {
        //       final result = await showDialog(
        //         context: context,
        //         builder: (_) => AddRegionDialog(cityId: widget.cityId),
        //       );
        //       if (result == true) {
        //         _fetchCity();
        //       }
        //     },
        //   ),
        // ],
      ),

      body: FutureBuilder<CityModel>(
        future: _futureCity,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final city = snapshot.data!;
            if (city.regions.isEmpty) {
              return const Center(child: Text('لا توجد مناطق في هذه المدينة.'));
            }
            return ListView.builder(
              itemCount: city.regions.length,
              itemBuilder: (context, index) {
                final region = city.regions[index];
                return LocationCard(
                  title: region.name,
                  subtitle: 'سعر التوصيل: ${region.price}',
                  onEditPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تعديل ${region.name}')),
                    );
                  },
                  onDeletePressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('حذف ${region.name}')),
                    );
                  },
                  onAddPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => AddRegionDialog(cityId: widget.cityId),
                    );
                    if (result == true) {
                      _fetchCity();
                    }
                  },
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
