import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';

class InformationAbout extends StatelessWidget {
  const InformationAbout({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                WhiteContainer(myWidget: BodyGraduation()),
                EduTrackContainer(),
                LinesImage(),
                WhiteContainer(
                  myWidget: BodyGraduation(),
                ),
                HomeRowNameAndImage(
                  myImage: AppImages.information,
                  myWidget: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "معلومات عن قسم",
                        style: getArabBoldItalicTextStyle(
                          context: context,
                          fontSize: 20.sp,
                          color: AppColors.mywhite,
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "تكنولوجيا التعليم",
                        style: getArabBoldItalicTextStyle(
                          context: context,
                          fontSize: 20.sp,
                          color: AppColors.myBrightTurquoise,
                        ),
                      ),
                    ],
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

class BodyGraduation extends StatelessWidget {
  const BodyGraduation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RichText(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                style: getArabLightTextStyle(
                  context: context,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text:
                        'يعد قسم تكنولوجيا التعليم من أهم الأقسام بكليات التربية والتربية النوعية، \n',
                  ),
                  TextSpan(
                    text: 'ولكن كانت النظرة له نظرة ضيقة ومحدودة \n',
                  ),
                  TextSpan(
                    text:
                        'فكان البعض ينظر لتكنولوجيا التعليم بأنه مجرد أجهزة ومعدات ووسائل تعليمية.',
                  ),
                  TextSpan(
                    text:
                        'مع التطور السريع والهائل في عصر المعلوماتية والاتصالات، ',
                  ),
                  TextSpan(
                    text:
                        'وما يشهده العصر من تقنيات وتطبيقات أثرت في كافة نواحي الحياة،\n ',
                  ),
                  TextSpan(
                    text: 'تطور معها مفهوم تكنولوجيا التعليم.\n\n',
                  ),
                  TextSpan(
                    text: 'تعريف تكنولوجيا التعليم:\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.myBlue,
                    ),
                  ),
                  TextSpan(
                    text:
                        'التكنولوجيا عامة تعني تطبيق المعرفة العلمية لحل المشكلات العلمية، \n',
                  ),
                  TextSpan(
                    text: 'فمن ثم تعني تكنولوجيا التعليم:\n',
                  ),
                  TextSpan(
                    text:
                        'التطبيق المنهجي المنظم للأبحاث والنظريات التجريبية الخاصة بعمليات التعليم والتعلم\n ومصادر التعلم، ',
                  ),
                  TextSpan(
                    text:
                        'وتوظيف كافة العناصر البشرية وغير البشرية (المادية) في مجالي التعليم والتعلم لمعالجة المشكلات ',
                  ),
                  TextSpan(
                    text:
                        'بهدف تحسين كفاءة التعليم وزيادة فاعليته وتحقيق التعلم المطلوب.\n\n',
                  ),
                  TextSpan(
                    text: 'أهداف القسم:\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.myBlue,
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text('• ', style: TextStyle(color: Colors.red[800])),
                          Expanded(
                            child: Text(
                              style: getArabLightTextStyle(
                                fontSize: 15,
                                context: context,
                                color: Colors.black,
                              ),
                              'إعداد أجيال متخصصة من المصممين التعليميين المشهود لهم بالكفاءة \nفي أداء مهامهم وبصورة تتسم بالتميز والفاعلية',
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text('• ', style: TextStyle(color: Colors.red[800])),
                          Expanded(
                            child: Text(
                              style: getArabLightTextStyle(
                                context: context,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              'المشاركة في تطوير المعرفة البحثية المرتبطة بمجال تكنولوجيا التعليم',
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              color: Colors.red[800],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              style: getArabLightTextStyle(
                                fontSize: 15,
                                context: context,
                                color: Colors.black,
                              ),
                              'الانفتاح على المؤسسات والهيئات الرسمية والأهلية من خلال التعاون معها لخدمة المجتمع محلياً وإقليمياً',
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
