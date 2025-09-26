import 'package:buyzoonapp/core/func/show_snak_bar.dart';
import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/features/location/Governorates/data/model/governorate_model.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/governorate_delete_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/governorate_delete_state.dart';
import 'package:buyzoonapp/features/location/Governorates/presentation/manger/governorates_list_cubit.dart';
import 'package:buyzoonapp/features/location/Governorates/repo/governorate_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// تأكد من استيراد GovernoratesListCubit و GovernoratesListState و GovernorateDeleteCubit و GovernorateDeleteState
// تأكد من استيراد GovernoratesListCubit, Governorate, Palette, showCustomSnackBar

class DeleteGovernorateDialog extends StatelessWidget {
  final GovernorateModel governorate;
  final BuildContext listCubitContext; // سياق قائمة المحافظات لتحديثها

  const DeleteGovernorateDialog({
    super.key,
    required this.governorate,
    required this.listCubitContext,
  });

  @override
  Widget build(BuildContext context) {
    // ⚠️ توفير Cubit الحذف داخل الـ Dialog
    return BlocProvider(
      create: (_) => GovernorateDeleteCubit(
        listCubitContext.read<GovernorateRepo>(),
      ), // يمكن الحصول على Repo من السياق إذا كان متوفراً
      child: AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد أنك تريد حذف محافظة ${governorate.name}؟'),
        actions: [
          TextButton(
            // الإغلاق متاح دائماً ما لم يكن هناك تحميل
            onPressed: () {
              final isDeleting =
                  context.read<GovernorateDeleteCubit>().state
                      is GovernorateDeleteLoading;
              if (!isDeleting) {
                Navigator.pop(context);
              }
            },
            child: const Text('إلغاء'),
          ),

          // ⚠️ استخدام BlocConsumer لـ GovernoratesDeleteCubit
          BlocConsumer<GovernorateDeleteCubit, GovernorateDeleteState>(
            listener: (listenerContext, state) {
              if (state is GovernorateDeleteSuccess) {
                // 1. إظهار رسالة النجاح
                showCustomSnackBar(
                  listCubitContext,
                  state.message,
                  color: Palette.success,
                );
                // 2. تحديث قائمة المحافظات
                listCubitContext
                    .read<GovernoratesListCubit>()
                    .fetchGovernorates();
                // 3. إغلاق الحوار
                Navigator.pop(listenerContext);
              } else if (state is GovernorateDeleteFailure) {
                // 1. إظهار رسالة الخطأ
                showCustomSnackBar(
                  listCubitContext,
                  state.error,
                  color: Palette.error,
                );
                // 2. إغلاق الحوار
                Navigator.pop(listenerContext);
              }
            },
            builder: (builderContext, state) {
              final isLoading = state is GovernorateDeleteLoading;

              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        builderContext
                            .read<GovernorateDeleteCubit>()
                            .deleteGovernorate(governorate.id);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('حذف'), // عرض مؤشر التحميل أو النص
              );
            },
          ),
        ],
      ),
    );
  }
}
