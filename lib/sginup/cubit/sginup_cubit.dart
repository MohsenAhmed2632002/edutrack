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

part 'sginup_state.dart';

class SginupCubit extends Cubit<SginupState> {
  SginupCubit() : super(SginUpInitial());
  final FireBaseAuth _auth = FireBaseAuth();
  final LocalUserData _localUserData = LocalUserData();
  final FireSoterUser _firestoreUser = FireSoterUser();

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
      final userCredential = await _auth.signUpWithEmailAndPassword(
        email: email,
        password: password,
        context: context,
        name: name,
        study_Group: study_Group,
        specialization: specialization,
      );

      final updatedUser = UserModel(
        name: myUser.name,
        email: email,
        userId: userCredential!.user!.uid,
        passWord: password,
        study_Group: myUser.study_Group,
        specialization: myUser.specialization,
      );

      _firestoreUser.addUserToFireStore(updatedUser);
      _localUserData.setUserData(updatedUser);
 print('User data to save: ${updatedUser.toJson()}'); // قبل الحفظ
      print(
          'Saved data: ${LocalUserData.prefs?.getString(LocalUserData.userDataKey)}'); // بعد الحفظ
      // إظهار رسالة النجاح

      _showSuccessSnackBar(context, name);
      emit(SginUpSuccess());

      // الانتقال إلى الصفحة التالية فقط عند النجاح
      Navigator.pushReplacementNamed(
        context,
        Routes.HomePageRoute,
      );
      if (userCredential.user?.uid == null) {
        _showErrorSnackBar(
            context, 'فشل إنشاء الحساب: بيانات المستخدم غير صالحة');
        emit(SginUpFailed('فشل إنشاء الحساب'));
        return;
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapAuthErrorToMessage(e);
      _showErrorSnackBar(context, errorMessage);
      emit(SginUpFailed(errorMessage));
    } on Exception catch (e) {
      print("Signup error: ${e.toString()}");
      final errorMessage = 'حدث خطأ غير متوقع أثناء إنشاء الحساب';
      _showErrorSnackBar(context, errorMessage);
      emit(SginUpFailed(errorMessage));
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
