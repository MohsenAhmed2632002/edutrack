import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edutrack/core/Models/lecture_model.dart';
import 'package:hive/hive.dart';

class LectureSchedulePage extends StatefulWidget {
  const LectureSchedulePage({Key? key}) : super(key: key);

  @override
  State<LectureSchedulePage> createState() => _LectureSchedulePageState();
}

class _LectureSchedulePageState extends State<LectureSchedulePage> {
  final List<String> days = [
    'الجمعة',
    'الخميس',
    'الأربعاء',
    'الثلاثاء',
    'الإثنين',
    'الأحد',
    'السبت'
  ];

  late Box<LectureModel> lectureBox;
  List<LectureModel> _displayedLectures = [];
  bool isLoading = true;
  bool hasInternet = true;
  bool isFirstLoad = true;
  String errorMessage = '';

  String yearLabel = '';
  LocalUserData localUserData = LocalUserData();
  String selectedDay = 'السبت';
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _preparePage();
  }

  Future<void> _preparePage() async {
    await Hive.openBox('lecturesBox');
    await _loadUserYear();
    await fetchLecturesForDay(selectedDay);
  }

  Future<void> _loadUserYear() async {
    final user = await LocalUserData().getUserData();
    switch (user.study_Group.trim()) {
      case 'الفرقة الأولى':
        yearLabel = 'الفرقة الأولى';
        break;
      case 'الفرقة الثانية':
        yearLabel = 'الفرقة الثانية';
        break;
      case 'الفرقة الثالثة':
      case 'الفرقة الرابعة':
        yearLabel =
            '${user.study_Group.trim()} - ${user.specialization.trim()}';
        break;
      default:
        yearLabel = 'الفرقة الأولى';
    }
  }

  Future<void> fetchLecturesForDay(String day, {String search = ''}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final isOnline = await _hasInternet();

    if (isOnline) {
      try {
        final query = FirebaseFirestore.instance
            .collection('محاضرات')
            .doc(yearLabel)
            .collection('الأيام')
            .doc(day)
            .collection('محاضرات');

        final snapshot = (search.isEmpty)
            ? await query.get()
            : await query
                .where('المادة', isGreaterThanOrEqualTo: search)
                .where('المادة', isLessThanOrEqualTo: '$search\uf8ff')
                .get();

        final lectures = snapshot.docs
            .map((doc) => LectureModel.fromMap(doc.data(), day))
            .toList();

        await Hive.box('lecturesBox')
            .put(day, lectures.map((e) => e.toMap()).toList());

        setState(() {
          _displayedLectures = lectures;
          isLoading = false;
        });
      } catch (e) {
        await _loadFromCache(day, search);
      }
    } else {
      await _loadFromCache(day, search);
    }
  }

  Future<void> _loadFromCache(String day, String search) async {
    final box = Hive.box('lecturesBox');
    final raw = box.get(day, defaultValue: []) as List;
    final all = raw
        .map((e) => LectureModel.fromMap(Map<String, dynamic>.from(e), day))
        .toList();

    final filtered = search.isEmpty
        ? all
        : all
            .where((lec) =>
                lec.subject.toLowerCase().contains(search.toLowerCase()))
            .toList();

    setState(() {
      _displayedLectures = filtered;
      isLoading = false;
      errorMessage = filtered.isEmpty ? 'لا يوجد محاضرات مخزنة لهذا اليوم' : '';
    });
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

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
            context: context,
            color: AppColors.mywhite,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          color: AppColors.mywhite,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          EduTrackContainer(),
          const LinesImage(),
          CenterImageLecture(nameImage: AppImages.time2),

          // جدول المحاضرات
          Positioned(
            left: 0,
            right: 0,
            top: 250.h,
            child: SizedBox(
              height: 600.h,
              child: _buildMainContent(),
            ),
          ),
          // أزرار الأيام
          Positioned(
            left: 0,
            right: 0,
            top: 250.h,
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isSelected = selectedDay == day;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        day,
                        style: TextStyle(
                          color:
                              isSelected ? AppColors.myBlue : AppColors.mywhite,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.white,
                      backgroundColor: AppColors.myBlue,
                      onSelected: (_) => setState(() {
                        selectedDay = day;
                        fetchLecturesForDay(day, search: searchText);
                      }),
                    ),
                  );
                },
              ),
            ),
          ),

          //     حقل البحث
          Positioned(
            left: 0,
            right: 0,
            top: 200.h,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                onChanged: (value) {
                  setState(() => searchText = value.trim());
                  fetchLecturesForDay(selectedDay, search: value.trim());
                },
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
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: getArabBoldTextStyle(
                  context: context,
                  color: AppColors.mywhite,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              if (errorMessage.contains('أول مرة'))
                Icon(Icons.wifi_off, size: 50, color: AppColors.mywhite),
            ],
          ),
        ),
      );
    }

    if (_displayedLectures.isEmpty) {
      return Center(
        child: Text(
          'لا توجد محاضرات لهذا اليوم',
          style: getArabBoldTextStyle(
            context: context,
            color: Colors.white,
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
        itemCount: _displayedLectures.length,
        itemBuilder: (context, index) {
          final lecture = _displayedLectures[index];
          return Card(
            elevation: 6,
            child: ExpansionTile(
              textColor: AppColors.myBlue,
              title: Text(
                lecture.subject,
                style: getArabLightTextStyle12(
                  context: context,
                  color: AppColors.myBlue,
                ),
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
                      Text(
                        'المحاضر: ${lecture.doctor}',
                        style: const TextStyle(color: AppColors.myBlue),
                      ),
                      Text(
                        'المادة: ${lecture.subject}',
                        style: const TextStyle(color: AppColors.myBlue),
                      ),
                      Text(
                        'المكان: ${lecture.location}',
                        style: const TextStyle(color: AppColors.myBlue),
                      ),
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

class CenterImageLecture extends StatelessWidget {
  final String nameImage;
  const CenterImageLecture({
    required this.nameImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: MediaQuery.sizeOf(context).height * .1,
      child: Image.asset(
        nameImage,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
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
}
