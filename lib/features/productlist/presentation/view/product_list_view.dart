// // lib/features/productlist/presentation/view/products_screen.dart

// import 'package:buyzoonapp/core/func/float_action_button.dart';
// import 'package:buyzoonapp/core/util/api_service.dart';
// import 'package:buyzoonapp/core/widget/appar_widget,.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/add_new_product.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_state.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/manager/addcubit/add_new_product_cubit.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/manager/get_cubit/get_all_poduct_cubit.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/manager/get_cubit/get_all_poduct_state.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/manager/updatecubit/update_product_cubit.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/search_product_list.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/update_product_view.dart';
// import 'package:buyzoonapp/features/productlist/presentation/view/widget/card_product.dart';
// import 'package:buyzoonapp/features/productlist/repo/product_list_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProductsScreen extends StatefulWidget {
//   const ProductsScreen({super.key, required this.id});
//   final int id;

//   @override
//   State<ProductsScreen> createState() => _ProductsScreenState();
// }

// class _ProductsScreenState extends State<ProductsScreen> {
//   @override
//   initState() {
//     super.initState();
//     // Fetch all batches when the page is initialized
//     context.read<ProductsCubit>().getAllProducts(widget.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppareWidget(
//         automaticallyImplyLeading: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductSearchPage(idtype: widget.id),
//                 ),
//               );
//             },
//             icon: Icon(Icons.search),
//           ),
//         ],
//         title: 'المنتجات',
//       ),
//       body: BlocListener<AddProductCubit, AddProductState>(
//         listener: (context, state) {
//           if (state is AddProductSuccess) {
//             context.read<ProductsCubit>().getAllProducts(widget.id);
//           }
//         },
//         child: BlocBuilder<ProductsCubit, ProductsState>(
//           builder: (context, state) {
//             if (state is ProductsLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is ProductsSuccess) {
//               if (state.products.isEmpty) {
//                 return const Center(child: Text('لا توجد منتجات حاليًا.'));
//               }
//               return ListView.builder(
//                 itemCount: state.products.length,
//                 padding: const EdgeInsets.all(16.0),
//                 itemBuilder: (context, index) {
//                   final product = state.products[index];
//                   // final productPhotos = product.productPhotos;

//                   return CardProduct(
//                     product: product,
//                     onEdit: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               UpdateProductView(productModel: product),
//                         ),
//                       );
//                     },
//                     onDelete: () {
//                       print('Delete product: ${product.name}');
//                     },
//                   );
//                 },
//               );
//             } else if (state is ProductsFailure) {
//               return Center(
//                 child: Text(
//                   state.errorMessage,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               );
//             } else {
//               return const SizedBox();
//             }
//           },
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//       floatingActionButton: buildFloatactionBoutton(
//         context,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddNewProduct(id: 2)),
//           );
//         },
//       ),
//     );
//   }
// }
