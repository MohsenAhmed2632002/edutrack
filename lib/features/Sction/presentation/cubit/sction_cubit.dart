// section_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/features/Sction/domain/usecases/sction_usecase.dart';
import 'package:edutrack/features/Sction/presentation/cubit/sction_state.dart';

class SectionCubit extends Cubit<SectionState> {
  final SectionUsecase usecase;
  final LocalUserData localUserData;

  final days = [
    'الجمعة',
    'الخميس',
    'الأربعاء',
    'الثلاثاء',
    'الإثنين',
    'الأحد',
    'السبت'
  ];
  String selectedDay = 'السبت';
  String searchText = '';

  SectionCubit({required this.usecase, required this.localUserData})
      : super(SectionInitial());

  Future<void> loadSections() async {
    emit(SectionLoading());
    try {
      final user = await localUserData.getUserData();
      final yearLabel = (user.study_Group.trim() == 'الفرقة الثالثة' ||
              user.study_Group.trim() == 'الفرقة الرابعة')
          ? '${user.study_Group.trim()} - ${user.specialization.trim()}'
          : user.study_Group.trim();

      final result = await usecase.getSectionsForDay(yearLabel, selectedDay,
          search: searchText);
      result.fold(
        (f) =>
            emit(SectionError(f is CacheFailure ? f.message : 'لا يوجد اتصال')),
        (list) => emit(SectionLoaded(list)),
      );
    } catch (_) {
      emit(SectionError('حدث خطأ غير متوقع'));
    }
  }

  void changeDay(String day) {
    selectedDay = day;
    loadSections();
  }

  void searchSections(String txt) {
    searchText = txt;
    loadSections();
  }
}
