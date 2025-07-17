import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edutrack/core/Models/lecture_model.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Server/netWorkInfo.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/features/Lecture/data/datasources/localdata.dart';
import 'package:edutrack/features/Lecture/data/datasources/remotedata.dart';
import 'package:edutrack/features/Lecture/data/repositories/Lecture_repoImpl.dart';
import 'package:edutrack/features/Lecture/domain/usecases/Lecture_usecase.dart';
import 'package:edutrack/features/Lecture/presentation/cubit/lecture_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edutrack/core/widgets/shared_widgets.dart';
import 'package:hive/hive.dart';

class LectureSchedulePage extends StatelessWidget {
  const LectureSchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // افتح الصندوق مبكراً
    Hive.openBox('lecturesBox');

    // 1) ضمِّ الـ BlocProvider داخل الصفحة
    return BlocProvider(
      create: (_) {
        final cubit = LectureCubit(
          lectureUsecase: LectureUsecase(
            LectureRepoImpl(
              remoteData: LectureRemoteDataImpl(),
              localData: LectureLocalDataImpl(),
              networkInfo: NetworkInfoImpl(Connectivity()),
            ),
          ),
          localUserData: LocalUserData(),
        );
        cubit.loadLectures(); // جلب أولي ليوم السبت
        return cubit;
      },
      child: _LectureView(), // الـ View فعلياً
    );
  }
}

class _LectureView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'مواعيد المحاضرات',
          style: getArabLightTextStyle(
            color: AppColors.mywhite,
            fontSize: 20,
            context: context,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          color: AppColors.mywhite,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          EduTrackContainer(),
          const LinesImage(),
          _buildCenterImage(),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildCenterImage() {
    return Positioned(
      left: 0,
      right: 0,
      top: 100.h,
      child: Image.asset(
        AppImages.time2,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          return AnimatedOpacity(
            child: child,
            opacity: frame == null ? 0 : 1,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 250.h,
      bottom: 0,
      child: Column(
        children: [
          _buildSearchField(context),
          _buildDaysSelector(context),
          Expanded(child: _buildLecturesContent(context)),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          onChanged: (value) =>
              context.read<LectureCubit>().searchLectures(value),
          decoration: InputDecoration(
            hintText: 'ابحث عن المحاضرة',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
Widget _buildDaysSelector(BuildContext context) {
  return BlocBuilder<LectureCubit, LectureState>(
    builder: (context, state) {
      // نأخذ دائمًا Cubit الحالي
      final cubit = context.read<LectureCubit>();
      return SizedBox(
        height: 50.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cubit.days.length,
          itemBuilder: (context, index) {
            final day = cubit.days[index];
            final isSelected = cubit.selectedDay == day;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ChoiceChip(
                label: Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? AppColors.myBlue : AppColors.mywhite,
                  ),
                ),
                selected: isSelected,
                selectedColor: Colors.white,
                backgroundColor: AppColors.myBlue,
                onSelected: (_) => cubit.changeDay(day),
              ),
            );
          },
        ),
      );
    },
  );
}

  Widget _buildLecturesContent(BuildContext context) {
    return BlocBuilder<LectureCubit, LectureState>(
      builder: (context, state) {
        if (state is LectureLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LectureError) {
          return _buildErrorState(state, context);
        } else if (state is LectureLoaded) {
          return _buildLecturesList(
              state.lectures.cast<LectureModel>(), context);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildErrorState(LectureError state, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: getArabBoldTextStyle(
                color: AppColors.mywhite,
                fontSize: 18,
                context: context,
              ),
              textAlign: TextAlign.center,
            ),
            if (state.message.contains('اتصال'))
              const Icon(Icons.wifi_off, size: 50, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildLecturesList(List<LectureModel> lectures, BuildContext context) {
    if (lectures.isEmpty) {
      return Center(
        child: Text(
          'لا توجد محاضرات لهذا اليوم',
          style: getArabBoldTextStyle(
            color: Colors.white,
            context: context,
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
        itemCount: lectures.length,
        itemBuilder: (context, index) {
          final lecture = lectures[index];
          return Card(
            elevation: 6,
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: ExpansionTile(
              textColor: AppColors.myBlue,
              title: Text(
                lecture.subject,
                style: getArabLightTextStyle12(
                    color: AppColors.myBlue, context: context),
              ),
              collapsedBackgroundColor: AppColors.mywhite,
              children: [
                ListTile(
                  trailing: Text(
                    'الوقت: ${lecture.timeFrom} - ${lecture.timeTo}\nالتاريخ: ${lecture.date}',
                    style: const TextStyle(color: AppColors.myBlue),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المحاضر: ${lecture.doctor}',
                          style: const TextStyle(color: AppColors.myBlue)),
                      Text('المادة: ${lecture.subject}',
                          style: const TextStyle(color: AppColors.myBlue)),
                      Text('المكان: ${lecture.location}',
                          style: const TextStyle(color: AppColors.myBlue)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
