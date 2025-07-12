// login_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:edutrack/Login/domain/Use_Case/Login_UseCase.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Routing/Routes.dart';
import 'package:edutrack/core/Server/fire_store.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/repo/fire_base_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginUsecase) : super(LoginInitial());
  final LoginUsecase loginUsecase;
  Future<void> loginUser({
    required String email,
    required String password,
    required String name,
    required String studyGroup,
    required String specialization,
    required BuildContext context,
  }) async {
    emit(LoginLoading());
    try {
      final result = await loginUsecase.loginUserAndSaveDataUser(
        email: email,
        password: password,
        name: name,
        studyGroup: studyGroup,
        specialization: specialization,
        context: context,
      );

      result.fold(
        (failure) {
          emit(LoginFailed(error: failure.message));
        },
        (userCredential) {
          emit(LoginSuccess());
          Navigator.pushReplacementNamed(context, Routes.HomePageRoute);
        },
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapAuthErrorToMessage(e);
      emit(LoginFailed(error: 'فشل تسجيل الدخول: $errorMessage'));
    } catch (e) {
      print("Login error: ${e.toString()}");
      emit(const LoginFailed(error: 'حدث خطأ غير متوقع أثناء تسجيل الدخول'));
    }
  }

  String _mapAuthErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'too-many-requests':
        return 'محاولات تسجيل دخول كثيرة جداً، حاول لاحقاً';
      case 'operation-not-allowed':
        return 'عملية تسجيل الدخول غير مسموح بها';
      default:
        return e.message ?? 'حدث خطأ أثناء تسجيل الدخول';
    }
  }
}
