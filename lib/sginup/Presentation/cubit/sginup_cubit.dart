import 'package:bloc/bloc.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Routing/Routes.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/sginup/Domain/Sginup_Usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sginup_state.dart';

class SginupCubit extends Cubit<SginupState> {
  SginupCubit(this.sginupUsecase) : super(SginUpInitial());
  final SginupUsecase sginupUsecase;

  Future<void> sginUp({
    required BuildContext context,
    required UserModel myUser,
    required String email,
    required String password,
    required String name,
    required String study_Group,
    required String specialization,
  }) async {
    emit(SginUpLoading());
    try {
      try {
        final result = await sginupUsecase.sginUpUser(
          email: email,
          password: password,
          name: name,
          studyGroup: study_Group,
          specialization: specialization,
          context: context,
        );

        result.fold(
          (failure) {
            emit(SginUpFailed(failure.message));
          },
          (userCredential) {
            emit(SginUpSuccess());
            Navigator.pushReplacementNamed(context, Routes.HomePageRoute);
          },
        );
      } on FirebaseAuthException catch (e) {
        final errorMessage = _mapAuthErrorToMessage(e);
        emit(SginUpFailed('فشل تسجيل الدخول: $errorMessage'));
      } catch (e) {
        print("Login error: ${e.toString()}");
        emit(const SginUpFailed( 'حدث خطأ غير متوقع أثناء تسجيل الدخول'));
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapAuthErrorToMessage(e);
      _showErrorSnackBar(context, errorMessage);
      emit(SginUpFailed(errorMessage));
    } on Exception catch (e) {
      print("Signup error: ${e.toString()}");
      final errorMessage = 'حدث خطأ غير متوقع أثناء إنشاء الحساب';
      _showErrorSnackBar(context, errorMessage);
      emit(
        SginUpFailed(
          errorMessage,
        ),
      );
    }
  }

  void _showSuccessSnackBar(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "أهلاً $name \nتم إنشاء الحساب بنجاح",
          style: getArabLightTextStyle(
            context: context,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'حسناً',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: getArabLightTextStyle(
            context: context,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'حسناً',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  String _mapAuthErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'بريد إلكتروني غير صالح';
      case 'operation-not-allowed':
        return 'عملية إنشاء الحساب غير مسموح بها';
      case 'weak-password':
        return 'كلمة المرور ضعيفة، يجب أن تكون 6 أحرف على الأقل';
      case 'too-many-requests':
        return 'محاولات كثيرة جداً، حاول لاحقاً';
      default:
        return 'حدث خطأ أثناء إنشاء الحساب: ${e.message ?? e.code}';
    }
  }
}
