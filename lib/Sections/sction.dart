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
import 'package:hive/hive.dart';
import 'package:edutrack/core/Models/section_model.dart';

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

  late Box sectionBox; // غير مخصص لنوع معين
  List<SectionModel> _displayedSections = [];
  bool isLoading = true;
  bool hasInternet = true;
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
    sectionBox = await Hive.openBox('sectionsBox'); // فتح الصندوق مرة واحدة
    await _loadUserYear();
    await fetchSectionsForDay(selectedDay);
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

  Future<void> fetchSectionsForDay(String day, {String search = ''}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final isOnline = await _hasInternet();

    if (isOnline) {
      try {
        // استخدام المجموعة الصحيحة للسكاشن
        final query = FirebaseFirestore.instance
            .collection('سكاشن')
            .doc(yearLabel)
            .collection('الأيام')
            .doc(day)
            .collection('سكاشن');

        final QuerySnapshot snapshot;
        if (search.isNotEmpty) {
          snapshot = await query
              .where('المادة', isGreaterThanOrEqualTo: search)
              .where('المادة', isLessThanOrEqualTo: '$search\uf8ff')
              .get();
        } else {
          snapshot = await query.get();
        }

        // تحويل النتائج إلى SectionModel
        final sections = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return SectionModel.fromMap(data, day);
        }).toList();

        // حفظ في Hive باستخدام نفس المتغير
        await sectionBox.put(day, sections.map((e) => e.toMap()).toList());

        setState(() {
          _displayedSections = sections;
          isLoading = false;
          hasInternet = true;
        });
      } catch (e) {
        print('حدث خطأ أثناء جلب السكاشن: $e');
        setState(() {
          errorMessage = 'حدث خطأ أثناء جلب البيانات';
        });
        await _loadFromCache(day, search);
      }
    } else {
      await _loadFromCache(day, search);
    }
  }

  Future<void> _loadFromCache(String day, String search) async {
    try {
      // تأكد أن الصندوق مفتوح
      if (!sectionBox.isOpen) {
        sectionBox = await Hive.openBox('sectionsBox');
      }

      final raw = sectionBox.get(day, defaultValue: []) as List;
      final all = raw
          .map((e) => SectionModel.fromMap(Map<String, dynamic>.from(e), day))
          .toList();

      final filtered = search.isEmpty
          ? all
          : all
              .where((section) =>
                  section.subject.toLowerCase().contains(search.toLowerCase()))
              .toList();

      setState(() {
        _displayedSections = filtered;
        isLoading = false;
        hasInternet = false;
        errorMessage = filtered.isEmpty ? 'لا يوجد سكاشن مخزنة لهذا اليوم' : '';
      });
    } catch (e) {
      print('حدث خطأ أثناء تحميل البيانات المخزنة: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'خطأ في تحميل البيانات المخزنة';
      });
    }
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          EduTrackContainer(),
          const LinesImage(),
          CenterImageSection(nameImage: AppImages.time2),

          // جدول السكاشن
          Positioned(
            left: 0,
            right: 0,
            bottom: -20.h,
            child: SizedBox(
              height: 600.h,
              child: _buildMainContent(),
            ),
          ),

          // أزرار الأيام
          Positioned(
            left: 0,
            right: 0,
            bottom: 500.h,
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
                        fetchSectionsForDay(day, search: searchText);
                      }),
                    ),
                  );
                },
              ),
            ),
          ),

          // حقل البحث
          Positioned(
            left: 0,
            right: 0,
            bottom: 550.h,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                onChanged: (value) {
                  setState(() => searchText = value.trim());
                  fetchSectionsForDay(selectedDay, search: value.trim());
                },
                decoration: InputDecoration(
                  hintText: 'ابحث عن السكشن',
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
              if (errorMessage.contains('لا يوجد بيانات'))
                Icon(Icons.wifi_off, size: 50, color: AppColors.mywhite),
            ],
          ),
        ),
      );
    }

    if (_displayedSections.isEmpty) {
      return Center(
        child: Text(
          'لا توجد سكاشن لهذا اليوم',
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
        itemCount: _displayedSections.length,
        itemBuilder: (context, index) {
          final section = _displayedSections[index];
          return Card(
            elevation: 6,
            child: ExpansionTile(
              textColor: AppColors.myBlue,
              title: Text(
                section.subject,
                style: getArabLightTextStyle12(
                  context: context,
                  color: AppColors.myBlue,
                ),
              ),
              collapsedBackgroundColor: AppColors.mywhite,
              children: [
                ListTile(
                  trailing: Text(
                    'الوقت: ${section.timeFrom} - ${section.timeTo}\nالتاريخ: ${section.date}',
                    style: const TextStyle(color: AppColors.myBlue),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المحاضر: ${section.doctor}',
                        style: const TextStyle(color: AppColors.myBlue),
                      ),
                      Text(
                        'المادة: ${section.subject}',
                        style: const TextStyle(color: AppColors.myBlue),
                      ),
                      Text(
                        'المكان: ${section.location}',
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

class CenterImageSection extends StatelessWidget {
  final String nameImage;
  const CenterImageSection({
    required this.nameImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 500.h,
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
