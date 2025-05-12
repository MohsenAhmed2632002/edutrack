import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionSchedulePage extends StatefulWidget {
  const SectionSchedulePage({Key? key}) : super(key: key);

  @override
  State<SectionSchedulePage> createState() => _SectionSchedulePageState();
}

class _SectionSchedulePageState extends State<SectionSchedulePage> {
  final List<String> days = [
    'الجمعة',
    'الخميس',
    'الأربعاء',
    'الثلاثاء',
    'الإثنين',
    'الأحد',
    'السبت'
  ];
  LocalUserData localUserData = LocalUserData();
  String yearLabel = '';

  String selectedDay = 'السبت';
  String searchText = '';
  Future<QuerySnapshot>? _futureSections; // ← لاحظ: صار nullable
  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  void initializeUserData() async {
    final user = await localUserData.getUserData();

    setState(() {
      // نحذف أي مسافات زائدة
      yearLabel = user.study_Group.trim();

      if (yearLabel == 'الفرقة الثالثة' || yearLabel == 'الفرقة الرابعة') {
        yearLabel = '$yearLabel - ${user.specialization.trim()}';
      }

      print('✅ Final yearLabel for sections: [$yearLabel]');
      print('yearLabel length: ${yearLabel.length}');

      // بعد تجهيز yearLabel نبدأ نجلب السكاشن
      _futureSections = fetchSectionsForDay(selectedDay);
    });
  }

  Future<QuerySnapshot> fetchSectionsForDay(String day) async {
    if (yearLabel.isEmpty) {
      throw Exception('yearLabel is not initialized yet!');
    }

    try {
      print('🔵 Fetching sections for day: [$day] and yearLabel: [$yearLabel]');

      final snapshot = await FirebaseFirestore.instance
          .collection('سكاشن') // تأكد أنك تجيب من سكاشن مش محاضرات
          .doc(yearLabel)
          .collection('الأيام')
          .doc(day)
          .collection('سكاشن')
          .get();

      if (snapshot.docs.isEmpty) {
        print('⚠️ No sections found for [$day] under [$yearLabel]');
      }

      return snapshot;
    } catch (e) {
      print('❌ Error while fetching sections: $e');
      rethrow; // نخليه يطلع فوق لو حابب تظهر رسالة خطأ للمستخدم
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
          'مواعيد السكاشن',
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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
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
                hintText: 'ابحث عن موعد السكاشن',
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
                future: _futureSections,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                  }
                  if (_futureSections == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final lectures = snapshot.data?.docs ?? [];
                  print('Fetched lectures: ${lectures.length}');

                  if (lectures.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد سكاشن لهذا اليوم',
                        style: getArabBoldTextStyle(
                            context: context, color: Colors.white),
                      ),
                    );
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
                        _futureSections = fetchSectionsForDay(day);
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
          CenterImage(
            nameImage: AppImages.time2,
          ),
        ],
      ),
    );
  }
}
