import 'package:animate_do/animate_do.dart';
import 'package:edutrack/core/Routing/Routes.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';

class AboutAs extends StatelessWidget {
  const AboutAs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          EduTrackContainer(),
          LinesImage(),
          WhiteContainer(
            myWidget: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                text: TextSpan(
                  style: getArabLightTextStyle(
                      context: context,
                      color: Colors.black,
                      fontSize: 16.sp.sp),
                  children: [
                    TextSpan(
                      text:
                          'نحن مجموعة من طلاب قسم تكنولوجيا التعليم بكلية التربية النوعية – جامعة عين شمس ',
                      style: getArabLightTextStyle(
                          context: context,
                          color:  AppColors.myBlue,
                          fontSize: 16.sp),
                    ),
                    TextSpan(
                      text:
                          'جمعنا الشغف بالتقنية الحديثة وحب تطوير العملية التعليمية، ',
                      style: getArabLightTextStyle(
                          context: context,
                          color: AppColors.myBlue,
                          fontSize: 16.sp),
                    ),
                    TextSpan(
                      text: 'فأنشأنا هذا التطبيق كجزء من مشروع تخرجنا.\n\n',
                      style: getArabLightTextStyle(
                          context: context,
                          color:  AppColors.myBlue,
                          fontSize: 16.sp),
                    ),
                    TextSpan(
                      text: 'يهدف تطبيقنا إلى:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    TextSpan(text: '• إدارة المناهج الدراسية بفعالية\n'),
                    TextSpan(
                        text: '• تنظيم المحتوى الأكاديمي بطريقة سهلة الوصول\n'),
                    TextSpan(
                        text:
                            '• تعزيز التواصل بين الطلاب وأعضاء هيئة التدريس\n\n'),
                    TextSpan(
                      text: 'مميزات التطبيق:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    TextSpan(text: '✓ متابعة المحاضرات\n'),
                    TextSpan(
                      text: 'رؤيتنا:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:  AppColors.myBlue,
                      ),
                    ),
                    TextSpan(
                      text:
                          'أن نكون رواداً في تحويل بيئات التعليم التقليدية إلى بيئات ذكية متكاملة\n\n',
                    ),
                    TextSpan(
                      text: 'رسالتنا:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.myBlue,
                      ),
                    ),
                    TextSpan(
                      text:
                          'تقديم حلول تقنية متطورة تدعم التعليم الجامعي وتسهّل إدارة المواد الدراسية\n\n',
                    ),
                    TextSpan(
                      text: 'قيمنا:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.myBlue,
                      ),
                    ),
                    TextSpan(text: 'الابتكار - '),
                    TextSpan(text: 'التواصل الفعّال - '),
                    TextSpan(text: 'الجودة - '),
                    TextSpan(text: 'العمل الجماعي - '),
                    TextSpan(text: 'التطوير المستمر'),
                  ],
                ),
              ),
            )),
          ),
          HomeRowNameAndImage(
            myImage: AppImages.about_as2,
            myWidget: FadeInRight(
              child: Text(
                "من نحن ؟",
                style: getArabBoldItalicTextStyle(
                  context: context,
                  color: AppColors.mywhite,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
