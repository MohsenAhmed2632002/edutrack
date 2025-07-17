import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
    required String name,
    required String study_Group,
    required String specialization,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, e.message ?? 'حدث خطأ أثناء تسجيل الدخول');
      return null;
    }
  }


  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String study_Group,
    required String specialization,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
          break;
        case 'user-not-found':
          errorMessage = 'المستخدم غير موجود';
          break;
        case 'wrong-password':
          errorMessage = 'كلمة المرور غير صحيحة';
          break;
        default:
          errorMessage = 'حدث خطأ غير متوقع: ${e.message}';
      }
      showErrorSnackBar(context, errorMessage);
      return null;
    } catch (e) {
      showErrorSnackBar(context, 'حدث خطأ غير متوقع');
      return null;
    }
  }
}
