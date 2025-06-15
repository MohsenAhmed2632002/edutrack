import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          EduTrackContainer(),
          const LinesImage(),
          const FrequentlyImage(),
          const WhiteContainer(),
        ],
      ),
    );
  }
}

class FrequentlyImage extends StatelessWidget {
  const FrequentlyImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
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
                return AnimatedOpacity(
                  child: child,
                  opacity: wasSynchronouslyLoaded ? 1 : (frame == null ? 0 : 1),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              },
            ),
          ),
          Column(
            children: [
              Text(
                "الاسئلة",
                style: getArabBoldItalicTextStyle(
                  context: context,
                  fontSize: 20,
                  color: AppColors.myBrightTurquoise,
                ),
              ),
              Text(
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
    );
  }
}

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      height: 700.h,
      child: SingleChildScrollView(
        child: Column(
          children: _buildFAQItems(context),
        ),
      ),
    );
  }

  List<Widget> _buildFAQItems(BuildContext context) {
    final faqItems = [
      _buildFAQItem(
        question: "ممكن اشتغل اي بعد التخرج من القسم ؟",
        answer: """
 كأخصائي تكنولوجيا التعليم
   - المدارس: أخصائي تكنولوجيا تعليم - تجهيز وسائل تعليمية
   - الجامعات: دعم التعليم الإلكتروني - إنتاج محتوى تعليمي
   - الشركات: مصمم تعليمي - مطور محتوى تفاعلي
   - العمل الحر: تصميم فيديوهات تعليمية - كتب رقمية - عروض تقديمية

 كمعلم حاسب آلي
   - المدارس: تدريس الحاسب الآلي والبرمجة الأساسية
   - مراكز التدريب: مدرب ICDL - برامج Office - أساسيات البرمجة
   - الشركات: مبرمج مبتدئ - دعم فني تقني
   - العمل الحر: شرح أونلاين - تصميم تطبيقات ومواقع بسيطة
""",
      ),
      _buildFAQItem(
        question: "هل القسم بيحتاج اكون شاطر في الكمبيوتر",
        answer:
            "مش شرط تكون محترف من البداية ولكن لازم تكون حابب المجال و مستعد تتعلم برامج زي\nالفوتوشوب\nالباوربوينت\nبرامج المونتاج\nادوات التصميم التعليمي مثل\nCanva & Articuate Storyline\nو بعض برامج التصميم و البرمجة",
      ),
      _buildFAQItem(
        question: "المجال له شغل فعلا ولا نظري بس",
        answer:
            "في شغل كتير و خصوصا بعد انتشار التعليم الالكتروني و مجالاته كتير \nولكن لازم الطالب يتعلم ادوات سوق العمل و يشتغل علي نفسه",
      ),
      _buildFAQItem(
        question: "إيه الفرق بينه وبين قسم الحاسب الآلي؟",
        answer:
            "قسم تكنولوجيا التعليم بيركز على توظيف التكنولوجيا في العملية التعليمية أما الحاسب الآلي فبيركز على البرمجة وأنظمة التشغيل أكتر",
      ),
      _buildFAQItem(
        question: "المواد اللي بندرسها شكلها إيه؟",
        answer:
            "تصميم تعليمي\nوسائل تعليمية\nإنتاج الوسائل التكنولوجيةتصميم برامج تعليمية\nإنتاج الفيديو التعليمي\nتطبيقات الحاسب في التعليم\n",
      ),
      _buildFAQItem(
        question: "ينفع أكمل دراسات عليا في إيه؟",
        answer:
            "ينفع تكمل ماجستير ودكتوراه في تكنولوجيا التعليم، أو تعليم إلكتروني، أو تصميم تعليمي.",
      ),
      _buildFAQItem(
        question: "هل فيه تدريب عملي؟",
        answer:
            "فيه جزء من الدراسة بيكون عملي سواء في المعامل أو في المدارس خلال التربية العملية",
      ),
      _buildFAQItem(
        question: "الفرق بين اخصائي و معلم",
        answer:
            ":اولا \n:دور المعلم و هو مسؤول عن \nشرح الدروس\nتصحيح الواجبات\nوضع الامتحانات\nتقييم الطلاب\n:الوظيفة\nمعلم فصل و ماده له جدول حصص و فصل تعليمي بيشرحه\n\n:ثانيا\n:الاخصائي\n:الدور\nبيساعد المعلمين في استخدام الوسائل التعليمية و التكنولوجيا\nبيصمم انشطة و وسائل تعليمية تتناسب مع  المناهج\nبيشغل المعمل و يتابع اجهزة الكمبيوتر و يشرف علي صيانتها\nيساعد في انتاج فيديوهات تعليمية او عروض تقديمية للمدرسين و الطلبة\n:الوظيفة\nمش بيشرح المنهج زي المعلم لكنه بيساعد في طريقة الشرح و تطويرها \nبيشتغل اكتر في الكواليس في دعم العملية التعليمية",
      ),
    ];

    final List<Widget> widgets = [];
    for (int i = 0; i < faqItems.length; i++) {
      widgets.add(faqItems[i]);
      if (i < faqItems.length - 1) {
        widgets.add(SizedBox(height: 20.h));
      }
    }
    return widgets;
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Builder(
      builder: (context) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
            iconColor: AppColors.myBlue,
            collapsedIconColor: AppColors.myBlue,
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            textColor: AppColors.myBlue,
            collapsedTextColor: AppColors.myBlue,
            childrenPadding: EdgeInsets.zero,
            title: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                question,
                style: getArabLightTextStyle12(
                  context: context,
                  color: AppColors.myBlue,
                  fontSize: 12.sp,
                ),
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  answer,
                  textAlign: TextAlign.end,
                  style: getArabLightTextStyle12(
                    context: context,
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
