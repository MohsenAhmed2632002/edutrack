import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:edutrack/Splash/Domain/splash_UseCase.dart';
import 'package:equatable/equatable.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.splashUsecase) : super(SplashInitial());
  final SplashUsecase splashUsecase;
  Future<bool> ifUserLoggedBeFore() async {
    emit(
      SplashLoading(),
    );
    var result = await splashUsecase.checkUserLoginBefore();
    emit(
      SplashUserLoggedBefore(
        loggedIn: result,
      ),
    );
    return result;
  }
}
