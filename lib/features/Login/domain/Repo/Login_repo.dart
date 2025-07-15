import 'package:dartz/dartz.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class LoginRepo {
  Future<Either<Failure, UserCredential>> loginUserAndSaveDataUser({
   required String email,
   required String password,
   required BuildContext context,
   required String name,
   required String study_Group,
   required String specialization,
  });
}
