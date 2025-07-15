import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lecture_state.dart';

class LectureCubit extends Cubit<LectureState> {
  LectureCubit() : super(LectureInitial());
}
