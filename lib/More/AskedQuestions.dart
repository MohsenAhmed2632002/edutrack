import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

class AskedQuestions extends StatelessWidget {
  const AskedQuestions({super.key});

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
              LinesImage(),
              WhiteContainer(),
              frequentlyImage(),
            ],
          ),
        ],
      ),
    );
  }
}

class frequentlyImage extends StatelessWidget {
  const frequentlyImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 650,
      child: Container(
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Hero(
              tag: "frequently",
              child: Image.asset(
                height: 100.h,
                width: 100.w,
                AppImages.frequently,
                fit: BoxFit.cover,
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
            ),
            Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "الاسئلة",
                  style: getArabBoldItalicTextStyle(
                    context: context,
                    fontSize: 20,
                    color: AppColors.myBrightTurquoise,
                  ),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "الشائعة",
                  style: getArabBoldItalicTextStyle(
                    context: context,
                    fontSize: 20,
                    color: AppColors.myBrightTurquoise,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      height: 700.h,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TapToExpand(
              iconColor: AppColors.myBlue,
              iconSize: 30,
              backgroundcolor: Colors.white,
              title: Text(
                "قسم تكنولجيا التعليم بيشتغل اي بعدالتخرج؟",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                  fontSize: 10.sp,
                ),
              ),
              content: Text(
                textAlign: TextAlign.end,
                "كأخصائي تكنولوجيا التعليم في المدارس\nفي شركات التعليم الالكتروني \n instructioal designer\nمصمم تعليمي و مطور محتوي\nفي بعض الجهات كمدرب أو مسؤول منصات تعليمية",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TapToExpand(
              iconColor: AppColors.myBlue,
              iconSize: 30,
              backgroundcolor: Colors.white,
              title: Text(
                "هل القسم بيحتاج اكون شاطر في الكمبيوتر",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
              content: Text(
                textAlign: TextAlign.end,
                "مش شرط تكون محترف من البداية ولكن لازم تكون حابب المجال و مستعد تتعلم برامج زي\nالفوتوشوب\nالباوربوينت\nبرامج المونتاج\nادوات التصميم التعليمي مثل\nCanva & Articuate Storyline\nو بعض برامج التصميم و البرمجة",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TapToExpand(
              iconColor: AppColors.myBlue,
              iconSize: 30,
              backgroundcolor: Colors.white,
              title: Text(
                "المجال له شغل فعلا ولا نظري بس ",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
              content: Text(
                textAlign: TextAlign.end,
                "في شغل كتير و خصوصا بعد انتشار التعليم الالكتروني و مجالاته كتير \nولكن لازم الطالب يتعلم ادوات سوق العمل و يشتغل علي نفسه",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TapToExpand(
              iconColor: AppColors.myBlue,
              iconSize: 30,
              backgroundcolor: Colors.white,
              title: Text(
                "إيه الفرق بينه وبين قسم الحاسب الآلي؟",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
              content: Text(
                textAlign: TextAlign.end,
                "قسم تكنولوجيا التعليم بيركز على توظيف التكنولوجيا في العملية التعليمية أما الحاسب الآلي فبيركز على البرمجة وأنظمة التشغيل أكتر",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TapToExpand(
              iconColor: AppColors.myBlue,
              iconSize: 30,
              backgroundcolor: Colors.white,
              title: Text(
                "المواد اللي بندرسها شكلها إيه؟",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
              content: Text(
                textAlign: TextAlign.end,
                "تصميم تعليمي\nوسائل تعليمية\nإنتاج الوسائل التكنولوجيةتصميم برامج تعليمية\nإنتاج الفيديو التعليمي\nتطبيقات الحاسب في التعليم\n",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TapToExpand(
              iconColor: AppColors.myBlue,
              iconSize: 30,
              backgroundcolor: Colors.white,
              title: Text(
                " ينفع أكمل دراسات عليا في إيه؟",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
              content: Text(
                textAlign: TextAlign.end,
                "ينفع تكمل ماجستير ودكتوراه في تكنولوجيا التعليم، أو تعليم إلكتروني، أو تصميم تعليمي.",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TapToExpand(
              iconColor: AppColors.myBlue,
              iconSize: 30,
              backgroundcolor: Colors.white,
              title: Text(
                "هل فيه تدريب عملي؟",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
              content: Text(
                textAlign: TextAlign.end,
                "فيه جزء من الدراسة بيكون عملي سواء في المعامل أو في المدارس خلال التربية العملية",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TapToExpand(
              iconColor: AppColors.myBlue,
              iconSize: 30,
              backgroundcolor: Colors.white,
              title: Text(
                " الفرق بين اخصائي و معلم",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
              content: Text(
                textAlign: TextAlign.end,
                ":اولا \n:دور المعلم و هو مسؤول عن \nشرح الدروس\nتصحيح الواجبات\nوضع الامتحانات\nتقييم الطلاب\n:الوظيفة\nمعلم فصل و ماده له جدول حصص و فصل تعليمي بيشرحه\n\n:ثانيا\n:الاخصائي\n:الدور\nبيساعد المعلمين في استخدام الوسائل التعليمية و التكنولوجيا\nبيصمم انشطة و وسائل تعليمية تتناسب مع  المناهج\nبيشغل المعمل و يتابع اجهزة الكمبيوتر و يشرف علي صيانتها\nيساعد في انتاج فيديوهات تعليمية او عروض تقديمية للمدرسين و الطلبة\n:الوظيفة\nمش بيشرح المنهج زي المعلم لكنه بيساعد في طريقة الشرح و تطويرها \nبيشتل اكتر في الكواليس في دعم العملية التعليمية",

                // "أولاً: المعلمالدور:* مسؤول عن شرح الدروس، تصحيح الواجبات، وضع امتحانات، تقييم الطلاب.الوظيفة:* معلم فصل أو معلم مادة* ليه جدول حصص ومقرر تعليمي بيشرحهثانيًا: الأخصائي (زي أخصائي تكنولوجيا التعليم)الدور:* بيساعد المعلمين في استخدام الوسائل التعليمية والتكنولوجيا* بيصمم أنشطة ووسائل تعليمية تناسب المناهج* بيشغّل المعامل وأجهزة الكمبيوتر، ويشرف على الصيانة والتنظيم* بيساعد في إنتاج فيديوهات تعليمية أو عروض تقديمية للمدرسين والطلبةالوظيفة:* مش بيشرح منهج، لكنه بيساعد في تطوير طرق الشرح* بيشتغل أكتر خلف الكواليس في دعم العملية التعليم",
                style: getArabLightTextStyle12(
                  color: AppColors.myBlue,
                  context: context,
                ),
              ),
            ),
          ],
          // ),
        ),
      ),
    );
  }
}
