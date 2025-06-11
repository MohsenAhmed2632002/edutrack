import 'package:animate_do/animate_do.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';

class AboutAs extends StatelessWidget {
  AboutAs({super.key});

  final List<Map<String, String>> participants = const [
    {
      'name': 'مني رمضان حسن',
      'image': AppImages.mona,
    },
    {
      'name': 'مي عبدالسلام محمد',
      'image': AppImages.mai,
    },
    {
      'name': 'شمس عربي نبيل',
      'image': AppImages.shams,
    },
    {
      'name': 'تقي ياسر ابراهيم',
      'image': AppImages.toqa,
    },
    {
      'name': 'سندس مصطفي ابراهيم',
      'image': AppImages.sondos,
    },
    {
      'name': 'شهد عماد حمدان',
      'image': AppImages.shahd,
    },
    {
      'name': 'ندي عمرو سمير',
      'image': AppImages.nada,
    },
    {
      'name': 'روان سعيد محمد',
      'image': AppImages.rawan,
    },
    {
      'name': 'منار عمرو محمد',
      'image': AppImages.manar,
    },
    {
      'name': 'زينب عماد عبدالرحيم',
      'image': AppImages.zainab,
    },
    {
      'name': 'هاجر مسعود عدوي',
      'image': AppImages.hager,
    },
    {
      'name': 'ابتسام احمد عبدالسلام',
      'image': AppImages.ebtsam,
    },
    {
      'name': 'فريد ايمن محمد',
      'image': AppImages.farid,
    },
  ];

  final List<String> supervisoryBoard = const [
    "ا. م. د. سهام عبدالحافظ",
    "د.محمود نصرالدين",
    "د.محمد عنتر ",
    "م. م.ايه بسيوني ",
    "م.احمد مكاوي",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // الخلفيات أولاً
          EduTrackContainer(),
          LinesImage(),

          // العنوان في الأعلى
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

          // المحتوى الرئيسي
          WhiteContainer(
            myWidget: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // النص الوصفي
                    RichText(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        style: getArabLightTextStyle(
                          context: context,
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'نحن مجموعة من طلاب قسم تكنولوجيا التعليم بكلية التربية النوعية – جامعة عين شمس ',
                            style: getArabLightTextStyle(
                              context: context,
                              color: AppColors.myBlue,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextSpan(
                            text:
                                'جمعنا الشغف بالتقنية الحديثة وحب تطوير العملية التعليمية، ',
                            style: getArabLightTextStyle(
                              context: context,
                              color: AppColors.myBlue,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextSpan(
                            text:
                                'فأنشأنا هذا التطبيق كجزء من مشروع تخرجنا.\n\n',
                            style: getArabLightTextStyle(
                              context: context,
                              color: AppColors.myBlue,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextSpan(
                            text: 'يهدف تطبيقنا إلى:\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.myBlue,
                            ),
                          ),
                          TextSpan(text: '• إدارة المناهج الدراسية بفعالية\n'),
                          TextSpan(
                              text:
                                  '• تنظيم المحتوى الأكاديمي بطريقة سهلة الوصول\n'),
                          TextSpan(
                              text:
                                  '• تعزيز التواصل بين الطلاب وأعضاء هيئة التدريس\n\n'),
                          TextSpan(
                            text: 'مميزات التطبيق:\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.myBlue,
                            ),
                          ),
                          TextSpan(text: '✓ متابعة المحاضرات\n'),
                          TextSpan(text: '✓ تسليم الواجبات\n'),
                          TextSpan(text: '✓ التواصل مع المدرسين\n\n'),
                          TextSpan(
                            text: 'رؤيتنا:\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.myBlue,
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

                    const SizedBox(height: 24),

                    // عنوان قسم المشاركين|
                    Center(
                      child: Text(
                        "فريق العمل",
                        style: getArabBoldTextStyle(
                          context: context,
                          color: AppColors.myBlue,
                          fontSize: 20.sp,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // قائمة المشاركين
                    ...participants
                        .map(
                          (participant) => Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30, // حجم مناسب
                                backgroundImage:
                                    AssetImage(participant['image']!),
                              ),
                              title: Text(
                                participant['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        )
                        .toList(),

                    const SizedBox(height: 16),

                    // عنوان قسم الاشراف|
                    Center(
                      child: Text(
                        "تحت اشراف",
                        style: getArabBoldTextStyle(
                          context: context,
                          color: AppColors.myBlue,
                          fontSize: 20.sp,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // قائمة المشاركين
                    ...supervisoryBoard
                        .map(
                          (supervisoryBoard) => Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                supervisoryBoard,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
