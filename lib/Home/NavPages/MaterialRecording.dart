import 'package:animate_do/animate_do.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter/material.dart';

class MaterialRecording extends StatelessWidget {
  const MaterialRecording({super.key});

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        style: getArabLightTextStyle(
                            context: context,
                            color: Colors.black,
                            fontSize: 18,),
                        children: [
                          // متطلبات الجامعة
                          TextSpan(
                            text: 'متطلبات الجامعة:\n',
                            style: getArabLightTextStyle(
                                context: context,
                                color:Colors.blue,
                                fontSize: 18),
                          ),

                          // العنوان الرئيسي
                          TextSpan(
                              text: 'اللغة الإنجليزية\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          // // متطلبات الكلية
                          TextSpan(
                            text: 'مقررات متطلبات الكلية:\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'مقررات التخصص الاجبارية:\n',
                            style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                                fontSize: 18),
                          ),
                          TextSpan(
                              text: '• مدخل إلى العلوم التربوية\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• المناهج وتنظيماتها\n\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• مدخل إلى تكنولوجيا التعليم\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• مقدمة الحاسبات والإنترنت\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• رياضيات ومنطق الحاسبات\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• علوم المكتبات الرقمية\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• تقنيات الرسومات التعليمية\n\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          // التخصص الاختياري
                          TextSpan(
                            text: 'مقررات التخصص الاختيارية:\n',
                            style: getArabLightTextStyle(
                                context: context,
                                color: Colors.blue,
                                fontSize: 18),
                          ),
                          TextSpan(
                            text: '(يختار الطالب مقررين منها)\n',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                              text: '• تطبيقات الحاسب المكتبية\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text:
                                  '• تقنيات إنتاج النماذج والعينات التعليمية\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• تصميم المعلومات البصرية وإنتاجها\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• تكنولوجيا الوسائط المتعددة والفائقة\n\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      "متطلبات المواد للفرقة الاولي الترم الاول و الثاني",
                      style: getArabRegulerTextStyle(
                        context: context,
                        fontSize: 14,
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        children: [
                          // متطلبات الجامعة
                          TextSpan(
                            text: 'متطلبات الكلية:\n',
                            style: getArabLightTextStyle(
                                context: context,
                                color: Colors.blueAccent,
                                fontSize: 18),
                          ),

                          // العنوان الرئيسي
                          TextSpan(
                              text: 'مدخل الي علوم نفسية\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: 'طرق تدريس عامة\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                            text: 'مقررات التخصص الاجبارية:\n',
                            style: getArabLightTextStyle(
                                context: context,
                                color: Colors.blue,
                                fontSize: 18),
                          ),
                          TextSpan(
                            text: '\n',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                              text: '• المتاحف و المعارض \n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• نظم تشغيل الحاسبات  و الاجهزة الذكية\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• مقدمة في البرمجة \n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• التصميم الجرافيكي\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• الاذاعة و التسجيلات الصوتية الرقمية\n\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),

                          // التخصص الاختياري
                          TextSpan(
                            text: 'مقررات التخصص الاختيارية:\n',
                            style: getArabLightTextStyle(
                                context: context,
                                color: Colors.blue,
                                fontSize: 18),
                          ),
                          TextSpan(
                            text: '(يختار الطالب مقررين منها)\n',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: '\n',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                              text: '• تطبيقات الحاسب المكتبية \n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• تقنيات النماذج و العينات التعليمية\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '• تصميم المعلومات البصرية و انتاجها  \n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: '•تكنولوجيا الوسائط المتعددة و الفائقة\n',
                              style: getArabLightTextStyle(
                                context: context,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          HomeRowNameAndImage(
            myImage: AppImages.lap,
            myWidget: FadeInRight(
              child: Text(
                "تسجيل المواد ",
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
