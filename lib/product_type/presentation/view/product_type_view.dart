import 'package:buyzoonapp/core/func/calculat_cross_axis_count.dart';
import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/func/show_menu.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/util/app_router.dart';
<<<<<<< HEAD
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/product_list_view.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
=======
import 'package:buyzoonapp/core/widget/empty_view_list.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/product_type/presentation/manger/add_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/delete_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/product_type/data/model/product_type_model.dart';
>>>>>>> 8dde4023b03c44fe9ca52dd155cd4cc1df643d1e

class ProductTypesScreen extends StatefulWidget {
  const ProductTypesScreen({super.key});

  @override
  State<ProductTypesScreen> createState() => _ProductTypesScreenState();
}

class _ProductTypesScreenState extends State<ProductTypesScreen> {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // تعريف قائمة العناصر التي سيتم عرضها

    return Scaffold(
      appBar: AppareWidget(
        title: 'أنواع المنتجات',
        automaticallyImplyLeading: true,
=======
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أنواع المنتجات',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
>>>>>>> 8dde4023b03c44fe9ca52dd155cd4cc1df643d1e
      ),
      body: const ProductTypeBodyView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: buildFloatactionBoutton(
        context,
        onPressed: () {
          AppRoutes.pushNamed(context, AppRoutes.addproducttypeview);
        },
      ),
    );
  }
}

class ProductTypeBodyView extends StatelessWidget {
  const ProductTypeBodyView({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // عدد وهمي للعناصر
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: calculateCrossAxisCount(context), // عمودين
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0, // لجعل العناصر مربعة
=======
    return MultiBlocListener(
      listeners: [
        BlocListener<AddProductTypeCubit, AddProductTypeState>(
          listener: (context, state) {
            if (state is AddProductTypeSuccess) {
              showCustomSnackBar(
                context,
                'تمت الإضافة بنجاح',
                color: Palette.success,
              );
              // context.read<GetProductTypeCubit>().getProductTypes();
            } else if (state is AddProductTypeFailure) {
              showCustomSnackBar(context, state.error, color: Palette.error);
            }
          },
        ),
        BlocListener<DeleteProductTypeCubit, DeleteProductTypeState>(
          listener: (context, state) {
            if (state is DeleteProductTypeSuccess) {
              showCustomSnackBar(
                context,
                state.message,
                color: Palette.success,
              );
              context.read<GetProductTypeCubit>().getProductTypes();
            } else if (state is DeleteProductTypeFailure) {
              showCustomSnackBar(context, state.error, color: Palette.error);
            }
          },
        ),
      ],
      child: BlocBuilder<GetProductTypeCubit, GetProductTypeState>(
        builder: (context, state) {
          if (state is GetProductTypeLoading) {
            return const LoadingViewWidget();
          } else if (state is GetProductTypeSuccess) {
            if (state.productTypes.isEmpty) {
              return EmptyListViews(text: 'لا يوجد انواع منتجات حاليا');
            }
            return Stack(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.productTypes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: calculateCrossAxisCount(context),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final productType = state.productTypes[index];
                    return ProductTypeGridItem(productType: productType);
                  },
                ),
                BlocBuilder<DeleteProductTypeCubit, DeleteProductTypeState>(
                  builder: (context, deleteState) {
                    if (deleteState is DeleteProductTypeLoading) {
                      return Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          } else if (state is GetProductTypeFailure) {
            return Center(
              child: ShowErrorWidgetView.fullScreenError(
                errorMessage: state.error,
              ),
            );
          }
          return const SizedBox.shrink();
        },
>>>>>>> 8dde4023b03c44fe9ca52dd155cd4cc1df643d1e
      ),
      itemBuilder: (context, index) {
        return ProductTypeGridItem(name: 'تصنيف ${index + 1}', id: index + 1);
      },
    );
  }
}

class ProductTypeGridItem extends StatelessWidget {
  final String name;
  final int id;

  const ProductTypeGridItem({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> myMenuItems = [
      {
        'value': 'view',
        'icon': Icon(Icons.view_list, color: Palette.secandry),
        'title': 'عرض المنتجات',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductsScreen(id: 3)),
          );
        },
      },
      {
        'value': 'edit',
        'icon': Icon(Icons.edit, color: Palette.primary),
        'title': 'تعديل',
        'onTap': () {},
      },
      {
        'value': 'delete',
        'icon': const Icon(Icons.delete, color: Colors.red),
        'title': 'حذف',
        'onTap': () {},
      },
    ];
    return GestureDetector(
      onTapDown: (details) {
        showProductMenu(
          context: context,
          position: details.globalPosition,
          menuItems: myMenuItems,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.secandry.withValues(alpha: 0.1),
              border: Border.all(color: Palette.secandry, width: 2),
            ),
            child: Icon(Icons.category, color: Palette.secandry, size: 40),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// import 'package:buyzoonapp/core/util/api_service.dart';
// import 'package:buyzoonapp/core/widget/error_widget_view.dart';
// import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
// import 'package:buyzoonapp/product_type/presentation/view/add_product_type_view.dart';
// import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProductTypesScreen extends StatelessWidget {
//   const ProductTypesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           ProductTypeCubit(ProductTypeRepo(ApiService(Dio())))
//             ..getProductTypes(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('أنواع المنتجات'),
//           backgroundColor: Colors.deepPurple,
//           foregroundColor: Colors.white,
//           centerTitle: true,
//         ),
//         body: BlocBuilder<ProductTypeCubit, ProductTypeState>(
//           builder: (context, state) {
//             if (state is ProductTypeLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(color: Colors.deepPurple),
//               );
//             } else if (state is ProductTypeSuccess) {
//               if (state.productTypes.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'لا توجد أنواع منتجات متاحة',
//                     style: TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: state.productTypes.length,
//                 itemBuilder: (context, index) {
//                   final productType = state.productTypes[index];
//                   return Card(
//                     elevation: 3,
//                     margin: const EdgeInsets.only(bottom: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.deepPurple.shade100,
//                         child: Text(
//                           '${index + 1}',
//                           style: const TextStyle(
//                             color: Colors.deepPurple,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         productType.name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward_ios,
//                         color: Colors.deepPurple.shade300,
//                         size: 16,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else if (state is ProductTypeFailure) {
//               return ShowErrorWidget.fullScreenError(errorMessage: state.error);
//             }

//             return const SizedBox.shrink();
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             // Navigate to add product type screen
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const AddProductTypeScreen(),
//               ),
//             );
//           },
//           backgroundColor: Colors.deepPurple,
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       ),
//     );
//   }
// }
