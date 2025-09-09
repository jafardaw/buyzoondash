import 'package:buyzoonapp/core/util/api_service.dart';

import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductTypesScreen extends StatelessWidget {
  const ProductTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductTypeCubit(ProductTypeRepo(ApiService(Dio())))
            ..getProductTypes(), // يتم استدعاء الدالة عند إنشاء الـ Cubit
      child: Scaffold(
        appBar: AppBar(title: const Text('أنواع المنتجات')),
        body: BlocBuilder<ProductTypeCubit, ProductTypeState>(
          builder: (context, state) {
            if (state is ProductTypeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductTypeSuccess) {
              return ListView.builder(
                itemCount: state.productTypes.length,
                itemBuilder: (context, index) {
                  final productType = state.productTypes[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(productType.id.toString()),
                    ),
                    title: Text(productType.name),
                  );
                },
              );
            } else if (state is ProductTypeFailure) {
              return Center(child: Text('فشل جلب البيانات: ${state.error}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
