// lib/features/location/Governorates/presentation/view/governorates_page.dart

import 'package:buyzoonapp/core/func/float_action_button.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/util/api_service.dart';
import 'package:buyzoonapp/core/widget/appar_widget,.dart';
import 'package:buyzoonapp/core/widget/loading_view.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/governorates_list_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/governorates_list_state.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/add_governorate_page.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/city/cities_page.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/location_card.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/view/widget/update_governorate_dialog.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GovernoratesPage extends StatefulWidget {
  const GovernoratesPage({super.key});

  @override
  State<GovernoratesPage> createState() => _GovernoratesPageState();
}

class _GovernoratesPageState extends State<GovernoratesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // This method now takes a context parameter
  void _onScroll(BuildContext context) {
    if (_isBottom) {
      context.read<GovernoratesListCubit>().loadMoreGovernorates();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GovernoratesListCubit(GovernorateRepo(ApiService()))
            ..fetchGovernorates(),
      child: Builder(
        builder: (providerContext) {
          return Scaffold(
            appBar: AppareWidget(
              automaticallyImplyLeading: true,
              title: 'المحافظات',
              actions: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () async {
                    final result = await Navigator.push(
                      providerContext,
                      MaterialPageRoute(
                        builder: (ctx) => const AddGovernoratePage(),
                      ),
                    );
                    if (result == true) {
                      if (mounted) {
                        providerContext
                            .read<GovernoratesListCubit>()
                            .fetchGovernorates();
                      }
                    }
                  },
                ),
              ],
            ),

            body: BlocBuilder<GovernoratesListCubit, GovernoratesListState>(
              builder: (cubitContext, state) {
                _scrollController.removeListener(() => _onScroll(cubitContext));
                _scrollController.addListener(() => _onScroll(cubitContext));

                if (state is GovernoratesListLoading) {
                  return LoadingViewWidget(
                    type: LoadingType.imageShake,
                    imagePath:
                        'assest/images/SAVE_٢٠٢٥٠٨٢٩_٢٣٣٣٥١-removebg-preview.png', // مسار صورتك
                    size: 200, // حجم الصورة
                    color: Palette.primary, // اللون
                  );
                } else if (state is GovernoratesListFailure) {
                  return Center(child: Text('خطأ: ${state.error}'));
                } else if (state is GovernoratesListSuccess) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.governorates.length + (state.hasNextPage ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.governorates.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final governorate = state.governorates[index];
                      return LocationCard(
                        title: governorate.name,
                        subtitle: 'سعر التوصيل: ${governorate.price}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CitiesPage(
                                governorateId: governorate.id,
                                governorateName: governorate.name,
                              ),
                            ),
                          );
                        },
                        onEditPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (_) => UpdateGovernorateDialog(
                              governorate: governorate,
                            ),
                          );
                          if (result == true) {
                            cubitContext
                                .read<GovernoratesListCubit>()
                                .fetchGovernorates();
                          }
                        },
                        onDeletePressed: () {
                          cubitContext
                              .read<GovernoratesListCubit>()
                              .deleteGovernorate(governorate.id)
                              .then((_) {
                                ScaffoldMessenger.of(cubitContext).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم الحذف بنجاح!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              })
                              .catchError((error) {
                                ScaffoldMessenger.of(cubitContext).showSnackBar(
                                  SnackBar(
                                    content: Text('فشل الحذف: $error'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              });
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
