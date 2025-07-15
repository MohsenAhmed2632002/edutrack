import 'package:dartz/dartz.dart';
import 'package:edutrack/features/Login/domain/Repo/Login_repo.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginUsecase {
  final LoginRepo loginRepo;

  LoginUsecase(this.loginRepo);
  Future<Either<Failure, UserCredential>> loginUserAndSaveDataUser({
    required String email,
    required String password,
    required String name,
    required String studyGroup,
    required String specialization,
    required BuildContext context,
  }) {
    return loginRepo.loginUserAndSaveDataUser(
      email: email,
      context: context,
      name: name,
      password: password,
    specialization: specialization,
    study_Group: studyGroup);
  }
}
