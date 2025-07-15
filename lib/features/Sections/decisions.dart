import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              CenterImageDecisions(nameImage: AppImages.decisions),
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
      // bottom: 0,
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
        yearLabel = 'الفرقة الأولى'; // fallback
    }

    print(
        'study_Group: [${user.study_Group.trim()}] specialization: [${user.specialization.trim()}]');
    print('Final yearLabel used for fetch: [$yearLabel]');
    print('yearLabel length: ${yearLabel.length}');

    setState(() {
      _futureSubjects = fetchSubjectsWithFallback();
      isLoading = false;
    });
  }

  Future<List<String>> fetchSubjectsFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('مواد')
        .doc(yearLabel)
        .collection('المواد')
        .get();

    final subjects =
        snapshot.docs.map((doc) => doc['name'].toString()).toList();

    // ✅ حفظ البيانات في SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subjects_$yearLabel', jsonEncode(subjects));

    return subjects;
  }

  Future<List<String>> getSubjectsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('subjects_$yearLabel');
    if (cachedData != null) {
      return List<String>.from(jsonDecode(cachedData));
    }
    return [];
  }

  Future<List<String>> fetchSubjectsWithFallback() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // 📴 بدون إنترنت
      print("🚫 No internet. Loading from cache...");
      return await getSubjectsFromCache();
    } else {
      // 🌐 مع إنترنت
      print("✅ Connected to internet. Fetching from Firestore...");
      try {
        return await fetchSubjectsFromFirestore();
      } catch (e) {
        print("❌ Error fetching from Firestore: $e");
        return await getSubjectsFromCache(); // fallback to cache
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 500.h,
            child: FutureBuilder<List<String>>(
              future: _futureSubjects,
              builder: (context, snapshot) {
                if (isLoading ||
                    snapshot.connectionState == ConnectionState.waiting) {
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
                      child: Container(
                        height: 50.h,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.book_outlined, color: Colors.white),
                              Text(
                                subjects[index],
                                style: getArabLightTextStyle12(
                                  context: context,
                                  color: AppColors.mywhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //  ListTile(
                      //   leading: Icon(Icons.book_outlined, color: Colors.white),
                      //   trailing: Text(
                      //     subjects[index],
                      //     style: getArabLightTextStyle12(
                      //       context: context,
                      //       color: AppColors.mywhite,
                      //     ),
                      //   ),
                      // ),
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

class CenterImageDecisions extends StatelessWidget {
  final String nameImage;
  const CenterImageDecisions({
    required this.nameImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0.h,
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
