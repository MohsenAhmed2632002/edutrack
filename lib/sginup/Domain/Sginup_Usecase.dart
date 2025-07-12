import 'package:dartz/dartz.dart';
import 'package:edutrack/Login/domain/Repo/Login_repo.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/sginup/Domain/Sginup_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SginupUsecase {
  final SginUpRepo sginUpRepo;

  SginupUsecase(this.sginUpRepo);
  Future<Either<Failure, UserCredential>> sginUpUser({
    required String email,
    required String password,
    required String name,
    required String studyGroup,
    required String specialization,
    required BuildContext context,
  }) {
    return sginUpRepo.sginUpUser(
      email: email,
      context: context,
      name: name,
      password: password,
    specialization: specialization,
    study_Group: studyGroup);
  }
}
