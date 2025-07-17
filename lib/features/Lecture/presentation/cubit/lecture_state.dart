// lib/features/lecture/presentation/cubit/lecture_state.dart
part of 'lecture_cubit.dart';

abstract class LectureState {
  const LectureState();
}

class LectureInitial extends LectureState {}
class LectureLoading extends LectureState {}
class LectureLoaded extends LectureState {
  final List<LectureModel> lectures;
  const LectureLoaded(this.lectures);
}
class LectureError extends LectureState {
  final String message;
  const LectureError(this.message);
}
