import 'package:bloc/bloc.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/models/lecture_model.dart';
import 'package:edutrack/features/Lecture/domain/usecases/Lecture_usecase.dart';

part 'lecture_state.dart';
class LectureCubit extends Cubit<LectureState> {
  final LectureUsecase lectureUsecase;
  final LocalUserData localUserData;
  
  final List<String> days = [
    'الجمعة', 'الخميس', 'الأربعاء', 
    'الثلاثاء', 'الإثنين', 'الأحد', 'السبت'
  ];
  
  String selectedDay = 'السبت';
  String searchText = '';
  bool hasInternet = true;
  String errorMessage = '';

  LectureCubit({
    required this.lectureUsecase,
    required this.localUserData,
  }) : super(LectureInitial());

  Future<void> loadLectures() async {
    emit(LectureLoading());
    try {
      final yearLabel = await _getYearLabel();
      final result = await lectureUsecase.getLecturesForDay(
        yearLabel, 
        selectedDay,
        search: searchText,
      );

      result.fold(
        (failure) {
          errorMessage = _mapFailureToMessage(failure);
          hasInternet = failure is! NetworkFailure;
          emit(LectureError(errorMessage));
        },
        (lectures) {
          errorMessage = '';
          emit(LectureLoaded(lectures.cast<LectureModel>()));
        },
      );
    } catch (e) {
      errorMessage = 'حدث خطأ غير متوقع';
      emit(LectureError(errorMessage));
    }
  }

  void changeDay(String day) {
    selectedDay = day;
    loadLectures();
  }

  void searchLectures(String search) {
    searchText = search;
    loadLectures();
  }

  Future<String> _getYearLabel() async {
    final user = await localUserData.getUserData();
    switch (user.study_Group.trim()) {
      case 'الفرقة الأولى': return 'الفرقة الأولى';
      case 'الفرقة الثانية': return 'الفرقة الثانية';
      case 'الفرقة الثالثة':
      case 'الفرقة الرابعة':
        return '${user.study_Group.trim()} - ${user.specialization.trim()}';
      default: return 'الفرقة الأولى';
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) return 'لا يوجد اتصال بالإنترنت';
    if (failure is CacheFailure) return failure.message;
    return 'حدث خطأ غير متوقع';
  }
}