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
  Future<QuerySnapshot>? _futureLectures; // ← لاحظ: صار nullable

  bool isLoading = true; // مبدئياً جاري التحميل

  String yearLabel = '';
  LocalUserData localUserData = LocalUserData();
  String selectedDay = 'السبت';
  String searchText = '';

  @override
  void initState() {
    super.initState();
    initializeUserData(); // فقط هذا!
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
        yearLabel = 'الفرقة الأولى'; // fallback
    }

    print('Final yearLabel for fetching lectures: [$yearLabel]');
    print('yearLabel length: ${yearLabel.length}');

    setState(() {
      _futureLectures = fetchLecturesForDay(selectedDay);
      isLoading = false;
    });
  }

  Future<QuerySnapshot> fetchLecturesForDay(String day) async {
    if (yearLabel.isEmpty) {
      throw Exception("yearLabel is not initialized yet!");
    }

    try {
      print("Fetching lectures for day: [$day] and yearLabel: [$yearLabel]");

      final snapshot = await FirebaseFirestore.instance
          .collection('محاضرات')
          .doc(yearLabel)
          .collection('الأيام')
          .doc(day)
          .collection('محاضرات')
          .get();

      if (snapshot.docs.isEmpty) {
        print("No lectures found for day [$day] and year [$yearLabel]");
      }

      return snapshot;
    } catch (e) {
      print('Error while fetching lectures: $e');
      rethrow; // عشان تقدر تتحكم في الخطأ لو حابب تعرض رسالة
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          EduTrackContainer(),
          const LinesImage(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 500.h,
            child: TextField(
              onChanged: (value) => setState(() => searchText = value),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: -80.h,
            child: SizedBox(
              height: 600.h,
              child: FutureBuilder<QuerySnapshot>(
                future: _futureLectures,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_futureLectures == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                  }

                  final lectures = snapshot.data?.docs ?? [];
                  print('Fetched lectures: ${lectures.length}');

                  if (lectures.isEmpty) {
                    return Center(
                        child: Text(
                      'لا توجد محاضرات لهذا اليوم',
                      style: getArabBoldTextStyle(
                          context: context, color: Colors.white),
                    ));
                  }

                  final filteredLectures = lectures.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title']?.toString() ?? '';
                    return title.contains(searchText);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredLectures.length,
                    itemBuilder: (context, index) {
                      final data = filteredLectures[index].data()
                          as Map<String, dynamic>;
                      return Card(
                        elevation: 6,
                        child: ExpansionTile(
                          textColor: AppColors.myBlue,
                          title: Text(
                            data['المادة'] ?? data['title'] ?? 'محاضرة',
                            style: getArabLightTextStyle12(
                                context: context, color: Colors.white),
                          ),
                          collapsedBackgroundColor: AppColors.myBlue,
                          children: [
                            ListTile(
                              trailing: Text(
                                'الوقت: ${data['من'] ?? data['time'] ?? ''} - ${data['إلى'] ?? data['time'] ?? ''}\nالتاريخ: ${data['date'] ?? ''}',
                                style: const TextStyle(
                                  color: AppColors.myBlue,
                                ),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'المحاضر: ${data['الدكتور'] ?? data['instructor'] ?? 'غير محدد'}',
                                    style: const TextStyle(
                                      color: AppColors.myBlue,
                                    ),
                                  ),
                                  Text(
                                    'المادة: ${data['المادة'] ?? data['title'] ?? 'غير محددة'}',
                                    style: const TextStyle(
                                      color: AppColors.myBlue,
                                    ),
                                  ),
                                  Text(
                                    'المكان: ${data['المكان'] ?? data['location'] ?? 'غير محدد'}',
                                    style: const TextStyle(
                                      color: AppColors.myBlue,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 450.h,
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
                        _futureLectures = fetchLecturesForDay(day);
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
          CenterImage(nameImage: AppImages.time2),
        ],
      ),
    );
  }
}
