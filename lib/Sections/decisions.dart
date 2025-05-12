import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DecisionsPage extends StatelessWidget {
  const DecisionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      body: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              EduTrackContainer(),
              WhiteContainer(
                myWidget: BodyGraduation(),
              ),
              BlueContainer(
                myWidget: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "المقررات الدراسية",
                    style: getArabLightTextStyle(
                      context: context,
                      color: AppColors.mywhite,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              LinesImage(),
              CenterImage(nameImage: AppImages.decisions),
            ],
          ),
        ],
      ),
    );
  }
}

class EduTrackContainer extends StatelessWidget {
  EduTrackContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        image: DecorationImage(
          image: AssetImage(
            AppImages.edu_track,
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class WhiteContainer extends StatelessWidget {
  final Widget myWidget;
  const WhiteContainer({
    super.key,
    required this.myWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      height: 600.h,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mywhite,
        ),
        child: myWidget,
      ),
    );
  }
}

class BlueContainer extends StatelessWidget {
  final Widget myWidget;
  const BlueContainer({
    super.key,
    required this.myWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 500.h,
      child: Container(
        height: 400.h,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                AppImages.edu_track,
              ),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: myWidget,
      ),
    );
  }
}

class BodyGraduation extends StatefulWidget {
  const BodyGraduation({super.key});

  @override
  State<BodyGraduation> createState() => _BodyGraduationState();
}

class _BodyGraduationState extends State<BodyGraduation> {
  LocalUserData localUserData = LocalUserData();
  Future<List<String>>? _futureSubjects;

  String yearLabel = '';
  bool isLoading = true;

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
        yearLabel = 'الفرقة الأولى'; // fallback قيمة افتراضية
    }

    print(
        'study_Group: [${user.study_Group.trim()}] specialization: [${user.specialization.trim()}]');
    print('Final yearLabel used for fetch: [$yearLabel]');
    print('yearLabel length: ${yearLabel.length}');

    setState(() {
      _futureSubjects = fetchSubjects();
      isLoading = false;
    });
  }

  Future<List<String>> fetchSubjects() async {
    if (yearLabel.isEmpty) {
      throw Exception("yearLabel is not initialized yet!");
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('مواد')
          .doc(yearLabel)
          .collection('المواد')
          .get();

      if (snapshot.docs.isEmpty) {
        print("No subjects found for $yearLabel");
      }

      return snapshot.docs.map((doc) => doc['name'].toString()).toList();
    } catch (e) {
      print('Error fetching subjects: $e');
      return []; // في حالة الخطأ رجع ليست فاضية عشان التطبيق يكمل
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 500.h,
            child: FutureBuilder<List<String>>(
              future: _futureSubjects,
              builder: (context, snapshot) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'حدث خطأ أثناء تحميل المواد',
                      style: getArabBoldTextStyle(
                          context: context, color: Colors.red),
                    ),
                  );
                }

                final subjects = snapshot.data ?? [];

                if (subjects.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد مواد مضافة لهذه الفرقة',
                      style: getArabBoldTextStyle(
                          context: context, color: AppColors.myBlue),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: AppColors.myBlue,
                      child: ListTile(
                        leading: Icon(Icons.book_outlined, color: Colors.white),
                        trailing: Text(
                          subjects[index],
                          style: getArabLightTextStyle12(
                              context: context, color: AppColors.mywhite),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LinesImage extends StatelessWidget {
  const LinesImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 500,
      child: const Image(
        // width: double.infinity,
        image: AssetImage(
          AppImages.lines,
        ),
      ),
    );
  }
}

class CenterImage extends StatelessWidget {
  final String nameImage;
  const CenterImage({
    required this.nameImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 550,
      child: Image.asset(nameImage),
    );
  }
}
// الفرقة الاولي 
// المتاحف و المعارض التعليمية 
// تقنيات الرسومات التعليمية
// نظم تشغيل الحاسب 
// مقدمة في البرمجة
// نظم تشغيل الحاسب
// التصميم الجرافيكي
// تطبيقات الحاسب المكتبية
// الاذاعة و التسجيلات الصوتية 
