import 'package:buyzoonapp/core/func/alert_dialog.dart';
import 'package:buyzoonapp/core/func/calculat_cross_axis_count.dart';
import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/func/show_menu.dart';
import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/util/app_router.dart';
import 'package:buyzoonapp/core/widget/empty_view_list.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/Order/presentation/view/order_list_view.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/search_cubit/search_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/product_list_view.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/search_product_list.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:buyzoonapp/product_type/presentation/manger/add_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/delete_product_type_cubit.dart';
import 'package:buyzoonapp/product_type/presentation/manger/product_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buyzoonapp/core/widget/error_widget_view.dart';
import 'package:buyzoonapp/product_type/data/model/product_type_model.dart';

class ProductTypesScreen extends StatefulWidget {
  const ProductTypesScreen({super.key});

  @override
  State<ProductTypesScreen> createState() => _ProductTypesScreenState();
}

class _ProductTypesScreenState extends State<ProductTypesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersView()),
              );
            },
            icon: Icon(Icons.assist_walker),
          ),
        ],
        title: const Text(
          'أنواع المنتجات',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
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
                    childAspectRatio:
                        0.7, // تقليل النسبة لإعطاء مساحة أكبر للارتفاع
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
                        color: Colors.black.withValues(alpha: 0.5),
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
    final List<Map<String, dynamic>> myMenuItems = [
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.secandry.withValues(alpha: 0.1),
                  border: Border.all(color: Palette.secandry, width: 2),
                ),
                child: const Icon(
                  Icons.category,
                  color: Palette.secandry,
                  size: 35,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  widget.productType.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
