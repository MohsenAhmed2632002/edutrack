part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  // final String userId;

  // const LoginSuccess({
  // required this.userId,});

  // @override
  // List<Object> get props => [userId];
}

final class LoginFailed extends LoginState {
  final String error;

  const LoginFailed({required this.error});

  @override
  List<Object> get props => [error];
}
