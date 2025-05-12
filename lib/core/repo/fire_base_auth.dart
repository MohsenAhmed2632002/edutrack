import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Server/fire_store.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Server/localuserdata.dart';

class FireBaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalUserData _localUserData = LocalUserData();
  final FireSoterUser _firestoreUser = FireSoterUser();
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

      if (userCredential.user == null) {
        showErrorSnackBar(context, 'فشل إنشاء الحساب: لا يوجد مستخدم');
        return null;
      }

      final userModel = UserModel(
        name: name,
        email: email,
        userId: userCredential.user!.uid,
        passWord: password,
        study_Group: study_Group,
        specialization: specialization,
      );

      await _firestoreUser.addUserToFireStore(userModel);
      await setUser(userModel);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, e.message ?? 'حدث خطأ أثناء التسجيل');
      return null;
    }
  }

  Future setUser(UserModel userModel) async {
    await _localUserData.setUserData(userModel);
  }

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

      if (userCredential.user == null) {
        showErrorSnackBar(context, 'فشل تسجيل الدخول: لا يوجد مستخدم');
        return null;
      }

      final userDoc =
          await _firestoreUser.getCurrentUser(userCredential.user!.uid);
      final userModel =
          UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      await _localUserData.setUserData(userModel);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, e.message ?? 'حدث خطأ أثناء تسجيل الدخول');
      return null;
    }
  }
}
