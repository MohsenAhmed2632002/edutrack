import 'package:edutrack/core/Theming/Font.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HowToGet extends StatelessWidget {
  const HowToGet({super.key});

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
      body: MainLayout(
        child: NameHalls(),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            const EduTrackContainer(),
            WhiteContainer(child: child),
            const LinesImage(),
            const CenterImage(nameImage: AppImages.map),
          ],
        ),
      ],
    );
  }
}

class EduTrackContainer extends StatelessWidget {
  const EduTrackContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        image: DecorationImage(
          image: AssetImage(AppImages.edu_track),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class WhiteContainer extends StatelessWidget {
  final Widget child;

  const WhiteContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      height: 600.h,
      child: Container(
        decoration: const BoxDecoration(color: AppColors.mywhite),
        child: child,
      ),
    );
  }
}

class LinesImage extends StatelessWidget {
  const LinesImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 550,
      child: const Image(image: AssetImage(AppImages.lines)),
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
      child: Hero(
        tag: "How",
        child: Image.asset(nameImage),
      ),
    );
  }
}

class NameHalls extends StatelessWidget {
  NameHalls({super.key});

  final Map<String, HallInfo> halls = {
    'مدرج سيد صبحي': HallInfo(
      images: [
        AppImages.photo_gam,
        AppImages.sobhy,
        AppImages.sobhy3,
      ],
      instructions: [
        'اذهب للساحه',
        'النزول من السلم الأيمن',
        'اتجه نحو اليسار ستجد المدرج في الناحيه اليمني',
      ],
    ),
    'مدرج آمال صادق': HallInfo(
      images: [
        AppImages.photo_gam,
        AppImages.sobhy,
        AppImages.amaldoor,
      ],
      instructions: [
        'اذهب للساحه',
        'النزول من السلم الأيمن',
        'ستجد المدرج في الناحيه اليمني',
      ],
    ),
    'معمل حاسب 1': HallInfo(
      images: [
        AppImages.tech11,
        AppImages.tech12,
        AppImages.tech13,
      ],
      instructions: [
        'اتجه نحو القصر من الناحيه الاماميه',
        'اتجه نحو اليمين ، ستجد المعمل في الناحيه اليسار',
        'الصعود من السل ستجد المعمل في الناحيه اليمني',
      ],
    ),
    'معمل حاسب 2': HallInfo(
      images: [
        AppImages.photo_gam,
        AppImages.sobhy,
        AppImages.tech21,
        AppImages.tech22,
        AppImages.tech23
      ],
      instructions: [
        'اذهب للساحه',
        'النزول من السلم الأيمن',
        'الصعود من السلم الأمامي الي الدور التاني',
        'امشي للأمام ثم اتجه نحو اليمين',
        'ستجد المعمل في الناحيه اليمني',
      ],
    ),
    'قاعة تكنولوجيا': HallInfo(
      images: [
        AppImages.photo_gam,
        AppImages.sobhy,
        AppImages.tech21,
        AppImages.tech_2
      ],
      instructions: [
        'اذهب للساحه',
        'النزول من السلم الأيمن',
        'الصعود من السلم الأمامي إلي الدور الأخير التوجه نحو آخر الطرقه ثم اتجه نحو اليسار',
        'ستجد المعمل في الناحيه اليمني',
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: halls.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final hallName = halls.keys.elementAt(index);
        final hallInfo = halls[hallName]!;

        return Card(
          color: AppColors.myBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 3,
          child: ListTile(
            title: Text(
              hallName,
              textAlign: TextAlign.center,
              style: getArabBoldTextStyle(
                context: context,
                fontSize: 20.sp,
                color: AppColors.mywhite,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ImageGalleryPage(
                  hallName: hallName,
                  hallInfo: hallInfo,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HallInfo {
  final List<String> images;
  final List<String> instructions;

  HallInfo({required this.images, required this.instructions});
}

class ImageGalleryPage extends StatefulWidget {
  final String hallName;
  final HallInfo hallInfo;

  const ImageGalleryPage({
    super.key,
    required this.hallName,
    required this.hallInfo,
  });

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  int currentIndex = 0;

  void _showNext() {
    if (currentIndex < widget.hallInfo.images.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void _showPrevious() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.hallName,
          style: getArabBoldTextStyle(
            context: context,
            fontSize: 20.sp,
            color: AppColors.mywhite,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: AppColors.mywhite,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: MainLayout(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                widget.hallInfo.images[currentIndex],
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),

            // إظهار خطوات الوصول
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Card(
                color: AppColors.mywhite,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'خطوات الوصول:',
                        style: getArabBoldTextStyle(
                          context: context,
                          fontSize: 18.sp,
                          color: AppColors.myBlue,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ...widget.hallInfo.instructions
                          .asMap()
                          .entries
                          .map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textDirection: TextDirection.rtl,
                            children: [
                              Text(
                                '${entry.key + 1}.',
                                style: getArabLightTextStyle(
                                  context: context,
                                  fontSize: 16.sp,
                                  color: AppColors.myBlue,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  textAlign: TextAlign.right,
                                  style: getArabLightTextStyle(
                                    context: context,
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            // أزرار التنقل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _showPrevious,
                  label: Text(
                    "السابق",
                    style: getArabLightTextStyle(
                      context: context,
                      color: AppColors.mywhite,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.myBlue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showNext,
                  label: Text(
                    "التالي",
                    style: getArabLightTextStyle(
                      context: context,
                      color: AppColors.mywhite,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.myBlue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
