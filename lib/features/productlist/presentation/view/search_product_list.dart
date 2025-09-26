import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/add_new_product.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/search_cubit/search_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/search_cubit/search_product_state.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/updatecubit/update_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/update_product_view.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/widget/card_product.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/widget/product_filtter_section.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({
    super.key,
    required this.idtype,
    required this.name,
  });

  final int idtype;
  final String name;
  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  // المفاتيح وأجهزة التحكم الخاصة بالفلتر تبقى هنا لأنها تدير حالة الفلتر
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  // String? _status;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _minStockAlertController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minStockAlertController.dispose();
    super.dispose();
  }

  void _search() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // إغلاق لوحة المفاتيح
      context.read<ProductSearchCubit>().searchRawMaterials(
        idype: widget.idtype,
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
        // description: _descriptionController.text.isNotEmpty
        //     ? _descriptionController.text
        //     : null,
        // status: _status,
        minPrice: _minPriceController.text.isNotEmpty
            ? double.parse(_minPriceController.text)
            : null,
        maxPrice: _maxPriceController.text.isNotEmpty
            ? double.parse(_maxPriceController.text)
            : null,
        minrating: _minStockAlertController.text.isNotEmpty
            ? double.parse(_minStockAlertController.text)
            : null,
      );
    }
  }

  void _onProductEdit(productModel) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<UpdateProductCubit>(
          create: (context) =>
              UpdateProductCubit(AddProductRepository(ApiService())),
          child: UpdateProductView(productModel: productModel),
        ),
      ),
    );
    // تحديث القائمة إذا كانت النتيجة "true"
    if (result == true) {
      context.read<ProductSearchCubit>().searchRawMaterials(
        idype: widget.idtype,
      );
    }
  }

  void _clearFilters() {
    _formKey.currentState!.reset();
    // _status = null;

    _nameController.clear();
    _descriptionController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    _minStockAlertController.clear();

    setState(() {}); // لتحديث حالة DropdownButtonFormField

    context.read<ProductSearchCubit>().searchRawMaterials(
      idype: widget.idtype,
    ); // بحث بدون فلاتر
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductSearchCubit>().searchRawMaterials(idype: widget.idtype);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(
        automaticallyImplyLeading: true,
        title: 'المنتجات الخاصة ب${widget.name}',
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: ProductFiltersSection(
                formKey: _formKey,
                nameController: _nameController,
                // descriptionController: _descriptionController,
                // status: _status,
                onStatusChanged: (newValue) {
                  setState(() {
                    // _status = newValue;
                  });
                },
                minPriceController: _minPriceController,
                maxPriceController: _maxPriceController,
                minStockAlertController: _minStockAlertController,
                onSearch: _search,
                onClearFilters: _clearFilters,
              ),
            ),
            SliverToBoxAdapter(child: const Divider(height: 1)),
          ];
        },
        body: ProductResultsSection(
          idype: widget.idtype,
          onEdit: _onProductEdit,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: buildFloatactionBoutton(
        context,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<AddProductCubit>(
                create: (context) =>
                    AddProductCubit(AddProductRepository(ApiService())),
                child: AddNewProduct(id: widget.idtype),
              ),
            ),
          ).then((result) {
            if (result == true) {
              context.read<ProductSearchCubit>().searchRawMaterials(
                idype: widget.idtype,
              );
            }
          });
        },
      ),
    );
  }
}

class ProductResultsSection extends StatelessWidget {
  const ProductResultsSection({
    super.key,
    required this.idype,
    required this.onEdit,
  });
  final int idype;
  final Function(dynamic) onEdit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSearchCubit, ProductSearchState>(
      builder: (context, state) {
        if (state is ProductSearchLoading) {
          return const LoadingViewWidget(
            type: LoadingType.imageShake,
            imagePath:
                'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
            size: 200, // حجم الصورة
          );
        } else if (state is RawMaterialSearchError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    // يمكنك استدعاء دالة البحث هنا مرة أخرى
                    // بما أن الـ cubit موجود في الشجرة، يمكننا الوصول إليه
                    context.read<ProductSearchCubit>().searchRawMaterials(
                      idype: idype,
                    );
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        } else if (state is RawMaterialSearchSuccess) {
          if (state.results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد نتائج',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'حاول تغيير معايير البحث',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final resultsearch = state.results[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CardProduct(
                  product: resultsearch,
                  onEdit: () {
                    onEdit(resultsearch);
                  },
                  onDelete: () {
                    print('Delete product: ${resultsearch.name}');
                  },
                ),
              );
            },
          );
        }
        // الحالة الأولية أو عندما لا تكون هناك نتائج بحث بعد
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'استخدم فلاتر البحث للبدء',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
