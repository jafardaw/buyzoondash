import 'package:buyzoonapp/features/auth/presentation/manger/login_state.dart';
import 'package:buyzoonapp/features/auth/repo/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginCubit extends Cubit<LoginState> {
//   final LoginRepo _loginRepo;

//   LoginCubit(this._loginRepo) : super(LoginInitial());

//   Future<void> login({
//     required String usernameOrPhone,
//     required String password,
//   }) async {
//     emit(LoginLoading());
//     try {
//       final loginModel = await _loginRepo.login(
//         usernameOrPhone: usernameOrPhone,
//         password: password,
//       );
//       emit(LoginSuccess(loginModel));
//     } on DioException catch (e) {
//       String errorMessage = ErrorHandler.handleDioError(e);
//       emit(LoginFailure(errorMessage));
//     } catch (error) {
//       emit(LoginFailure(error.toString()));
//     }
//   }
// }
// في ملف login_cubit.dart
// ...
class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(LoginInitial());

  Future<void> login({
    required String usernameOrPhone,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final loginModel = await _loginRepo.login(
        usernameOrPhone: usernameOrPhone,
        password: password,
      );
      emit(LoginSuccess(loginModel));
    } catch (e) {
      // هنا e ستحتوي على رسالة الخطأ الصحيحة من ErrorHandler
      emit(LoginFailure(e.toString()));
    }
  }
}
