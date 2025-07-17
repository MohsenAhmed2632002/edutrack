import 'package:dartz/dartz.dart';
import 'package:edutrack/features/Login/domain/Repo/Login_repo.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Server/fire_store.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:edutrack/core/Server/fire_base_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginRepoimpl extends LoginRepo {
  final FireBaseAuth fireBaseAuth;
  final LocalUserData localUserData;
  final FireSoterUser fireSoterUser;
  LoginRepoimpl(
    this.fireBaseAuth,
    this.localUserData,
    this.fireSoterUser,
  );
  @override
  Future<Either<Failure, UserCredential>> loginUserAndSaveDataUser({
    String? email,
    String? password,
    BuildContext? context,
    String? name,
    String? study_Group,
    String? specialization,
  }) async {
    final userCredential = await fireBaseAuth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
      context: context!,
      name: name!,
      specialization: specialization!,
      study_Group: study_Group!,
    );

    final userModel = UserModel(
      name: name,
      email: email,
      userId: userCredential!.user!.uid,
      passWord: password,
      study_Group: study_Group,
      specialization: specialization,
    );
      await fireSoterUser.updateUserInFireStore(userModel);
      await localUserData.setUserData(userModel);

    showSuccessLoginSnackBar(context, name);
    return Right(userCredential);
  }
}

void showSuccessLoginSnackBar(BuildContext context, String name) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          "أهلاً $name\nتم تسجيل الدخول بنجاح",
          style: getArabLightTextStyle(
            context: context,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'حسناً',
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ),
  );
}
