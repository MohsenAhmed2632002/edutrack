import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  Future<QuerySnapshot>? _futureLectures;
  bool isLoading = true;

  String yearLabel = '';
  LocalUserData localUserData = LocalUserData();
  String selectedDay = 'السبت';
  String searchText = '';

  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  void initializeUserData() async {
    final user = await localUserData.getUserData();

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

    setState(() {
      _futureLectures = fetchLecturesForDay(selectedDay);
      isLoading = false;
    });
  }

  Future<QuerySnapshot> fetchLecturesForDay(String day,
      {String search = ''}) async {
    if (yearLabel.isEmpty) {
      throw Exception("yearLabel is not initialized yet!");
    }

    try {
      final baseQuery = FirebaseFirestore.instance
          .collection('محاضرات')
          .doc(yearLabel)
          .collection('الأيام')
          .doc(day)
          .collection('محاضرات');

      if (search.isNotEmpty) {
        return await baseQuery
            .where('المادة', isGreaterThanOrEqualTo: search)
            .where('المادة', isLessThanOrEqualTo: '$search\uf8ff')
            .get();
      } else {
        return await baseQuery.get();
      }
    } catch (e) {
      print('Error while fetching lectures: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // حقل البحث
          Positioned(
            left: 0,
            right: 0,
            bottom: 450.h,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value.trim();
                  _futureLectures =
                      fetchLecturesForDay(selectedDay, search: searchText);
                });
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
          // جدول المحاضرات
          Positioned(
            left: 0,
            right: 0,
            bottom: -120.h,
            child: SizedBox(
              height: 600.h,
              child: FutureBuilder<QuerySnapshot>(
                future: _futureLectures,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      _futureLectures == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                  }

                  final lectures = snapshot.data?.docs ?? [];

                  if (lectures.isEmpty) {
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

                  return ListView.builder(
                    itemCount: lectures.length,
                    itemBuilder: (context, index) {
                      final data =
                          lectures[index].data() as Map<String, dynamic>;
                      return Card(
                        elevation: 6,
                        child: ExpansionTile(
                          textColor: AppColors.myBlue,
                          title: Text(
                            data['المادة'] ?? 'محاضرة',
                            style: getArabLightTextStyle12(
                              context: context,
                              color: Colors.white,
                            ),
                          ),
                          collapsedBackgroundColor: AppColors.myBlue,
                          children: [
                            ListTile(
                              trailing: Text(
                                'الوقت: ${data['من'] ?? ''} - ${data['إلى'] ?? ''}\nالتاريخ: ${data['date'] ?? ''}',
                                style: const TextStyle(color: AppColors.myBlue),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'المحاضر: ${data['الدكتور'] ?? 'غير محدد'}',
                                    style: const TextStyle(
                                        color: AppColors.myBlue),
                                  ),
                                  Text(
                                    'المادة: ${data['المادة'] ?? 'غير محددة'}',
                                    style: const TextStyle(
                                        color: AppColors.myBlue),
                                  ),
                                  Text(
                                    'المكان: ${data['المكان'] ?? 'غير محدد'}',
                                    style: const TextStyle(
                                        color: AppColors.myBlue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // أزرار الأيام
          Positioned(
            left: 0,
            right: 0,
            bottom: 400.h,
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
                        _futureLectures =
                            fetchLecturesForDay(day, search: searchText);
                      }),
                    ),
                  );
                },
              ),
            ),
          ),

          // صورة في المنتصف
          CenterImage(nameImage: AppImages.time2),
        ],
      ),
    );
  }
}
