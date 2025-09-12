// lib/features/productlist/presentation/view/products_screen.dart

import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/features/productlist/data/product_list_model.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/add_new_product.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_state.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/get_cubit/get_all_poduct_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/get_cubit/get_all_poduct_state.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/manager/updatecubit/update_product_cubit.dart';
import 'package:buyzoonapp/features/productlist/presentation/view/update_product_view.dart';
import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.id});
  final int id;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  initState() {
    super.initState();
    // Fetch all batches when the page is initialized
    context.read<ProductsCubit>().getAllProducts(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppareWidget(automaticallyImplyLeading: true, title: 'المنتجات'),
      body: BlocListener<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state is AddProductSuccess) {
            context.read<ProductsCubit>().getAllProducts(widget.id);
          }
        },
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsSuccess) {
              if (state.products.isEmpty) {
                return const Center(child: Text('لا توجد منتجات حاليًا.'));
              }
              return ListView.builder(
                itemCount: state.products.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  // final productPhotos = product.productPhotos;

                  return CardProduct(
                    product: product,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => UpdateProductCubit(
                              AddProductRepository(ApiService()),
                            ),
                            child: UpdateProductView(productModel: product),
                          ),
                        ),
                      );
                    },
                    onDelete: () {
                      print('Delete product: ${product.name}');
                    },
                  );
                },
              );
            } else if (state is ProductsFailure) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: buildFloatactionBoutton(
        context,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewProduct(id: 2)),
          );
        },
      ),
    );
  }
}
// lib/features/productlist/presentation/view/widgets/card_product.dart

class CardProduct extends StatefulWidget {
  const CardProduct({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productPhotos = widget.product.productPhotos;
    final bool hasPhotos = productPhotos != null && productPhotos.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images Carousel
            if (hasPhotos)
              Column(
                children: [
                  SizedBox(
                    height: 200, // Increased height for better visibility
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: productPhotos.length,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemBuilder: (context, photoIndex) {
                        final photo = productPhotos[photoIndex];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            photo.photoUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(productPhotos.length, (index) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            // Product Name and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Product Description
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Price and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.product.price.toStringAsFixed(2)} \$',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RatingBarIndicator(
                  rating: widget.product.rating,
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 22.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Product Type
            Row(
              children: [
                if (widget.product.productType != null)
                  Align(
                    alignment:
                        Alignment.centerRight, // Align to right for Arabic LTR
                    child: Chip(
                      label: Text(
                        'النوع: ${widget.product.productType!.name}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      backgroundColor: const Color.fromARGB(255, 144, 174, 189),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ),
                Spacer(),

                if (widget.onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: widget.onEdit,
                    tooltip: 'تعديل المنتج',
                  ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: widget.onDelete,
                    tooltip: 'حذف المنتج',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
