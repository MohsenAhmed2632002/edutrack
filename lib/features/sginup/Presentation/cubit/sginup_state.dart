// ✅ محدث ومحسن: sginup_state.dart
part of 'sginup_cubit.dart';

sealed class SginupState extends Equatable {
  const SginupState();

  @override
  List<Object> get props => [];
}

final class SginUpInitial extends SginupState {}

final class SginUpLoading extends SginupState {}

final class SginUpSuccess extends SginupState {}

final class SginUpFailed extends SginupState {
  final String errorMessage;
  const SginUpFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
