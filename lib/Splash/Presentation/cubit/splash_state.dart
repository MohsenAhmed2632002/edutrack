part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {

}

class SplashUserLoggedBefore extends SplashState {
  final bool loggedIn;

  SplashUserLoggedBefore({required this.loggedIn});
}
