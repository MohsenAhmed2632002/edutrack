import 'package:bloc/bloc.dart';
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
  LoginCubit() : super(LoginInitial());
  final FireBaseAuth _auth = FireBaseAuth();
  final LocalUserData _localUserData = LocalUserData();
  final FireSoterUser _fireSoterUser = FireSoterUser();

  Future<void> loginUser({
    required String email,
    required String password,
    required String name,
    
    required String study_Group,
    required String specialization,
    required BuildContext context,
  }) async {
    emit(LoginLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
        context: context,
        name: name,
        specialization: specialization,
        study_Group: study_Group,
      );
      // تحقق من وجود userCredential وبيانات المستخدم
      if (userCredential?.user!.uid == null) {
        emit(LoginFailed(
            error: 'فشل تسجيل الدخول: في اول مره يجب تشغيل الانترنت '));
        return;
      }




    
      // إنشاء نموذج المستخدم
      final userModel = UserModel(
        name: name,
        email: email,
        userId: userCredential!.user!.uid,
        passWord: password,
        study_Group: study_Group,
        specialization: specialization,
      );

      // تنفيذ العمليات بشكل متوازي حيث ممكن
 _fireSoterUser.updateUserInFireStore(userModel);
 _localUserData.setUserData(userModel);


      _showSuccessSnackBar(context, name);

      emit(LoginSuccess());

      // الانتقال إلى الصفحة التالية
      Navigator.pushReplacementNamed(
        context,
        Routes.HomePageRoute,
      );
    } on FirebaseAuthException catch (e) {
      // معالجة أخطاء Firebase المحددة
      final errorMessage = _mapAuthErrorToMessage(e);
      emit(LoginFailed(error: "فشل تسجيل الدخول: في اول مره يجب تشغيل الانترنت {$errorMessage}"));
    } on Exception catch (e) {
      // معالجة الأخطاء العامة
      print("Login error: ${e.toString()}");
      emit(LoginFailed(error: 'حدث خطأ غير متوقع أثناء تسجيل الدخول'));
    }
  }

  // دالة مساعدة لعرض رسالة النجاح
  void _showSuccessSnackBar(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "اهلا $name \nتم تسجيل الدخول بنجاح",
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

  // تحسين دالة معالجة الأخطاء لتشمل المزيد من حالات Firebase
  String _mapAuthErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'invalid-email':
        return 'بريد إلكتروني غير صالح';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'too-many-requests':
        return 'محاولات تسجيل دخول كثيرة جداً، حاول لاحقاً';
      case 'operation-not-allowed':
        return 'عملية تسجيل الدخول غير مسموح بها';
      default:
        return 'حدث خطأ أثناء تسجيل الدخول: ${e.message}';
    }
  }
}
