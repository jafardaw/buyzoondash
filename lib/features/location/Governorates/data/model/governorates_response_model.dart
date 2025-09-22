// lib/features/governorates/data/model/governorates_response_model.dart

import 'governorate_model.dart';

class GovernoratesResponseModel {
  final List<GovernorateModel> governorates;
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;

  GovernoratesResponseModel({
    required this.governorates,
    required this.currentPage,
    required this.lastPage,
    this.nextPageUrl,
  });

  factory GovernoratesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return GovernoratesResponseModel(
      governorates: (data['data'] as List)
          .map((e) => GovernorateModel.fromJson(e))
          .toList(),
      currentPage: data['current_page'] as int,
      lastPage: data['last_page'] as int,
      nextPageUrl: data['next_page_url'],
    );
  }
}
