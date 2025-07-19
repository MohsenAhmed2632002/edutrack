import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Server/netWorkInfo.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/widgets/shared_widgets.dart';
import 'package:edutrack/features/Sction/data/datasources/localdata.dart';
import 'package:edutrack/features/Sction/data/datasources/remotedata.dart';
import 'package:edutrack/features/Sction/data/repositories/SctionrepoImpl.dart';
import 'package:edutrack/features/Sction/domain/usecases/sction_usecase.dart';
import 'package:edutrack/features/Sction/presentation/cubit/sction_cubit.dart';
import 'package:edutrack/features/Sction/presentation/cubit/sction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

class SectionSchedulePage extends StatelessWidget {
  const SectionSchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Hive.openBox('sectionsBox');

    return BlocProvider(
      create: (_) {
        final cubit = SectionCubit(
          usecase: SectionUsecase(
            SectionRepoImpl(
              remote: SectionRemoteDataImpl(),
              local: SectionLocalDataImpl(),
              net: NetworkInfoImpl(Connectivity()),
            ),
          ),
          localUserData: LocalUserData(),
        );
        cubit.loadSections();
        return cubit;
      },
      child: _SectionView(),
    );
  }
}

class _SectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SectionCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('مواعيد السكاشن',
            style: getArabLightTextStyle(
                color: AppColors.mywhite, fontSize: 20, context: context)),
        centerTitle: true,
        leading: IconButton(
            color: AppColors.mywhite,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          EduTrackContainer(),
          const LinesImage(),
          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: Image.asset(AppImages.time2,
                frameBuilder: (c, ch, frame, w) => AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(seconds: 1),
                    child: ch)),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            top: 200.h,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                onChanged: cubit.searchSections,
                decoration: InputDecoration(
                  hintText: 'ابحث عن السكشن',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          BlocBuilder<SectionCubit, SectionState>(
            buildWhen: (_, __) => true, // اختياري
            builder: (context, state) {
              final cubit = context.read<SectionCubit>();
              return Positioned(
                top: 250.h,
                left: 0,
                right: 0,
                height: 50.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.days.length,
                  itemBuilder: (c, i) {
                    final d = cubit.days[i];
                    final sel = cubit.selectedDay == d;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ChoiceChip(
                        label: Text(d,
                            style: TextStyle(
                                color: sel
                                    ? AppColors.myBlue
                                    : AppColors.mywhite)),
                        selected: sel,
                        selectedColor: Colors.white,
                        backgroundColor: AppColors.myBlue,
                        onSelected: (_) => cubit.changeDay(d),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
              top: 300.h,
              bottom: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<SectionCubit, SectionState>(
                builder: (c, st) {
                  if (st is SectionLoading)
                    return const Center(child: CircularProgressIndicator());
                  if (st is SectionError) {
                    return Center(
                        child: Text(st.message,
                            style: getArabBoldTextStyle(
                                color: AppColors.mywhite, context: c)));
                  }
                  if (st is SectionLoaded && st.sections.isEmpty) {
                    return Center(
                        child: Text('لا توجد سكاشن لهذا اليوم',
                            style: getArabBoldTextStyle(
                                color: AppColors.mywhite, context: c)));
                  }
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView.builder(
                        itemCount: (st as SectionLoaded).sections.length,
                        itemBuilder: (_, i) {
                          final sec = st.sections[i];
                          return Card(
                            elevation: 6,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 16.w),
                            child: ExpansionTile(
                              textColor: AppColors.myBlue,
                              title: Text(sec.subject,
                                  style: getArabLightTextStyle12(
                                      color: AppColors.myBlue, context: c)),
                              children: [
                                ListTile(
                                  trailing: Text(
                                      'الوقت: ${sec.timeFrom} - ${sec.timeTo}\nالتاريخ: ${sec.date}',
                                      style: const TextStyle(
                                          color: AppColors.myBlue)),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('المحاضر: ${sec.doctor}',
                                          style: const TextStyle(
                                              color: AppColors.myBlue)),
                                      Text('المكان: ${sec.location}',
                                          style: const TextStyle(
                                              color: AppColors.myBlue)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  );
                },
              ))
        ],
      ),
    );
  }
}
