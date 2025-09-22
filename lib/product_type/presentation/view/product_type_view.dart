import 'package:buyzoonapp/core/func/alert_dialog.dart';
import 'package:buyzoonapp/core/func/calculat_cross_axis_count.dart';
import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/func/show_menu.dart';
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/app_router.dart';
import 'package:buyzoonapp/core/widget/empty_view_list.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/notifaction/presentation/view/broadcast_notification_view.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/search_cubit/search_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/search_product_list.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:buyzoonapp/product_type/presentation/manger/add_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/delete_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/product_type/data/model/product_type_model.dart';

import 'package:buyzoonapp/product_type/repo/product_type_repo.dart';
import 'package:buyzoonapp/core/util/api_service.dart';

class ProductTypesScreen extends StatefulWidget {
  const ProductTypesScreen({super.key});

  @override
  State<ProductTypesScreen> createState() => _ProductTypesScreenState();
}

class _ProductTypesScreenState extends State<ProductTypesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetProductTypeCubit>(
          create: (context) =>
              GetProductTypeCubit(ProductTypeRepo(ApiService()))
                ..getProductTypes(),
        ),
        BlocProvider<DeleteProductTypeCubit>(
          create: (context) =>
              DeleteProductTypeCubit(ProductTypeRepo(ApiService())),
        ),
        BlocProvider<AddProductTypeCubit>(
          create: (context) =>
              AddProductTypeCubit(ProductTypeRepo(ApiService())),
        ),
      ],
      child: Builder(
        builder: (multiProviderContext) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BroadcastNotificationScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: Palette.backgroundColor,
                  ),
                ),
              ],
              title: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    multiProviderContext
                        .read<GetProductTypeCubit>()
                        .searchProductTypes(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'البحث عن نوع منتج...',
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        multiProviderContext
                            .read<GetProductTypeCubit>()
                            .searchProductTypes('');
                      },
                    ),
                  ),
                ),
              ),
              backgroundColor: Palette.primary,
              elevation: 0,
            ),
            body: const ProductTypeBodyView(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: buildFloatactionBoutton(
              context,
              onPressed: () async {
                AppRoutes.pushNamed(
                  multiProviderContext,
                  AppRoutes.addproducttypeview,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductTypeBodyView extends StatefulWidget {
  const ProductTypeBodyView({super.key});

  @override
  State<ProductTypeBodyView> createState() => _ProductTypeBodyViewState();
}

class _ProductTypeBodyViewState extends State<ProductTypeBodyView> {
  @override
  Widget build(BuildContext context) {
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
              context.read<GetProductTypeCubit>().getProductTypes();
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
            return LoadingViewWidget(
              type: LoadingType.imageShake,
              imagePath:
                  'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
              size: 200, // حجم الصورة
              // اللون
            );
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
                onRetry: () {
                  context.read<GetProductTypeCubit>().getProductTypes();
                },
                errorMessage: state.error,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ProductTypeGridItem extends StatefulWidget {
  final ProductTypeModel productType;

  const ProductTypeGridItem({super.key, required this.productType});

  @override
  State<ProductTypeGridItem> createState() => _ProductTypeGridItemState();
}

class _ProductTypeGridItemState extends State<ProductTypeGridItem> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> myMenuItems = [
      {
        'value': 'view',
        'icon': const Icon(Icons.view_list, color: Palette.secandry),
        'title': 'عرض المنتجات',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<ProductSearchCubit>(
                    create: (context) => ProductSearchCubit(
                      repository: AddProductRepository(ApiService()),
                    ),
                  ),
                  BlocProvider<AddProductCubit>(
                    create: (context) =>
                        AddProductCubit(AddProductRepository(ApiService())),
                  ),
                ],
                child: ProductSearchPage(idtype: widget.productType.id),
              ),
            ),
          );
        },
      },
      {
        'value': 'edit',
        'icon': const Icon(Icons.edit, color: Palette.primary),
        'title': 'تعديل',
        'onTap': () {
          // AppRoutes.pushNamed(context, AppRoutes.updateproducttypview);
        },
      },
      {
        'value': 'delete',
        'icon': const Icon(Icons.delete, color: Colors.red),
        'title': 'حذف',
        'onTap': () {
          showCustomAlertDialog(
            context: context,
            title: 'تأكيد الحذف',
            content: 'هل أنت متأكد من حذف ${widget.productType.name}؟',
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<DeleteProductTypeCubit>().deleteProductType(
                    id: widget.productType.id,
                  );
                  Navigator.pop(context);
                },
                child: const Text('حذف'),
              ),
            ],
          );
        },
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
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.secandry.withOpacity(0.1),
                border: Border.all(color: Palette.secandry, width: 2),
              ),
              child: const Icon(
                Icons.category,
                color: Palette.secandry,
                size: 40,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.productType.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}







// class ProductTypesScreen extends StatefulWidget {
//   const ProductTypesScreen({super.key});

//   @override
//   State<ProductTypesScreen> createState() => _ProductTypesScreenState();
// }

// class _ProductTypesScreenState extends State<ProductTypesScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<GetProductTypeCubit>(
//           create: (context) =>
//               GetProductTypeCubit(ProductTypeRepo(ApiService()))
//                 ..getProductTypes(),
//         ),
//         BlocProvider<DeleteProductTypeCubit>(
//           create: (context) =>
//               DeleteProductTypeCubit(ProductTypeRepo(ApiService())),
//         ),
//         BlocProvider<AddProductTypeCubit>(
//           create: (context) =>
//               AddProductTypeCubit(ProductTypeRepo(ApiService())),
//         ),
//       ],
//       child: Builder(
//         // <-- هذا هو التعديل الأساسي
//         builder: (multiProviderContext) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Container(
//                 width: double.infinity,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: (query) {
//                     // نستخدم multiProviderContext هنا لضمان وصول صحيح للـ Cubit
//                     multiProviderContext
//                         .read<GetProductTypeCubit>()
//                         .searchProductTypes(query);
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'البحث عن نوع منتج...',
//                     border: InputBorder.none,
//                     prefixIcon: const Icon(Icons.search),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         multiProviderContext
//                             .read<GetProductTypeCubit>()
//                             .searchProductTypes('');
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               backgroundColor: Colors.green,
//               elevation: 0,
//               actions: const [SizedBox(width: 16)],
//             ),
//             body: const ProductTypeBodyView(),
//             floatingActionButtonLocation:
//                 FloatingActionButtonLocation.startFloat,
//             floatingActionButton: buildFloatactionBoutton(
//               multiProviderContext,
//               onPressed: () async {
//                 // نستخدم multiProviderContext هنا
//                 AppRoutes.pushNamed(
//                   multiProviderContext,
//                   AppRoutes.addproducttypeview,
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ProductTypeBodyView extends StatefulWidget {
//   const ProductTypeBodyView({super.key});

// class ProductTypeBodyView extends StatefulWidget {
//   const ProductTypeBodyView({super.key});

//   @override
//   State<ProductTypeBodyView> createState() => _ProductTypeBodyViewState();
// }

// class _ProductTypeBodyViewState extends State<ProductTypeBodyView> {
//   @override
//   State<ProductTypeBodyView> createState() => _ProductTypeBodyViewState();
// }

// class _ProductTypeBodyViewState extends State<ProductTypeBodyView> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<AddProductTypeCubit, AddProductTypeState>(
//           listener: (context, state) {
//             if (state is AddProductTypeSuccess) {
//               showCustomSnackBar(
//                 context,
//                 'تمت الإضافة بنجاح',
//                 color: Palette.success,
//               );
//               // بعد الإضافة بنجاح، نقوم بتحديث قائمة المنتجات
//               context.read<GetProductTypeCubit>().getProductTypes();
//             } else if (state is AddProductTypeFailure) {
//               showCustomSnackBar(context, state.error, color: Palette.error);
//             }
//           },
//         ),
//         BlocListener<DeleteProductTypeCubit, DeleteProductTypeState>(
//           listener: (context, state) {
//             if (state is DeleteProductTypeSuccess) {
//               showCustomSnackBar(
//                 context,
//                 state.message,
//                 color: Palette.success,
//               );
//               context.read<GetProductTypeCubit>().getProductTypes();
//             } else if (state is DeleteProductTypeFailure) {
//               showCustomSnackBar(context, state.error, color: Palette.error);
//             }
//           },
//         ),
//       ],
//       child: BlocBuilder<GetProductTypeCubit, GetProductTypeState>(
//         builder: (context, state) {
//           if (state is GetProductTypeLoading) {
//             return const LoadingViewWidget();
//           } else if (state is GetProductTypeSuccess) {
//             if (state.productTypes.isEmpty) {
//               return EmptyListViews(text: 'لا يوجد انواع منتجات حاليا');
//             }
//             return Stack(
//               children: [
//                 GridView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: state.productTypes.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: calculateCrossAxisCount(context),
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     childAspectRatio: 1.0,
//                   ),
//                   itemBuilder: (context, index) {
//                     final productType = state.productTypes[index];
//                     return ProductTypeGridItem(productType: productType);
//                   },
//                 ),
//                 BlocBuilder<DeleteProductTypeCubit, DeleteProductTypeState>(
//                   builder: (context, deleteState) {
//                     if (deleteState is DeleteProductTypeLoading) {
//                       return Container(
//                         color: Colors.black.withOpacity(0.5),
//                         child: const Center(child: CircularProgressIndicator()),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//               ],
//             );
//           } else if (state is GetProductTypeFailure) {
//             return Center(
//               child: ShowErrorWidgetView.fullScreenError(
//                 errorMessage: state.error,
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

// class ProductTypeGridItem extends StatefulWidget {
//   final ProductTypeModel productType;
// class ProductTypeGridItem extends StatefulWidget {
//   final ProductTypeModel productType;

//   const ProductTypeGridItem({super.key, required this.productType});
//   const ProductTypeGridItem({super.key, required this.productType});

//   @override
//   State<ProductTypeGridItem> createState() => _ProductTypeGridItemState();
// }

// class _ProductTypeGridItemState extends State<ProductTypeGridItem> {
//   @override
//   State<ProductTypeGridItem> createState() => _ProductTypeGridItemState();
// }

// class _ProductTypeGridItemState extends State<ProductTypeGridItem> {
//   @override
//   Widget build(BuildContext context) {
//      {
//         'value': 'view',
//         'icon': const Icon(Icons.view_list, color: Palette.secandry),
//         'title': 'عرض المنتجات',
//         'onTap': () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MultiBlocProvider(
//                 providers: [
//                   BlocProvider<ProductSearchCubit>(
//                     create: (context) => ProductSearchCubit(
//                       repository: AddProductRepository(ApiService()),
//                     ),
//                   ),

//                   BlocProvider<AddProductCubit>(
//                     create: (context) =>
//                         AddProductCubit(AddProductRepository(ApiService())),
//                   ),
//                 ],
//                 child: ProductSearchPage(idtype: widget.productType.id),
//               ),
//             ),
//           );
//         },
//       },
//       {
//         'value': 'edit',
//         'icon': const Icon(Icons.edit, color: Palette.primary),
//         'title': 'تعديل',
//         'onTap': () {
//           // AppRoutes.pushNamed(context, AppRoutes.updateproducttypview);
//         },
//       },
//       {
//         'value': 'delete',
//         'icon': const Icon(Icons.delete, color: Colors.red),
//         'title': 'حذف',
//         'onTap': () {
//           showCustomAlertDialog(
//             context: context,
//             title: 'تأكيد الحذف',
//             content: 'هل أنت متأكد من حذف ${widget.productType.name}؟',
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('إلغاء'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<DeleteProductTypeCubit>().deleteProductType(
//                     id: widget.productType.id,
//                   );
//                   Navigator.pop(context);
//                 },
//                 child: const Text('حذف'),
//               ),
//             ],
//           );
//         },
//       },
//     ];


//     return GestureDetector(
//       onTapDown: (details) {
//         showProductMenu(
//           context: context,
//           position: details.globalPosition,
//           menuItems: myMenuItems,
//         );
//       },
//       child: Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 70,
//               height: 70,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Palette.secandry.withOpacity(0.1),
//                 border: Border.all(color: Palette.secandry, width: 2),
//               ),
//               child: const Icon(
//                 Icons.category,
//                 color: Palette.secandry,
//                 size: 40,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               widget.productType.name,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// ضارب الاقواس واماكنن ظبطهن