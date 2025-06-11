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
                myWidget: NameHalls(),
              ),
              LinesImage(),
              CenterImage(nameImage: AppImages.map),
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

class LinesImage extends StatelessWidget {
  const LinesImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 550,
      child: const Image(
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

class NameHalls extends StatelessWidget {
  NameHalls({super.key});
  final halls = {
    'مدرج سيد صبحي': [
      AppImages.photo_gam,
      AppImages.sobhy,
      AppImages.sobhy3,
    ],
    'مدرج آمال صادق': [
      AppImages.photo_gam,
      AppImages.photo_gam,
      AppImages.sobhy,
      AppImages.amaldoor,
    ],
    'معمل حاسب 1': [
      AppImages.tech11,
      AppImages.tech12,
      AppImages.tech13,
    ],
    'معمل حاسب 2': [
      AppImages.photo_gam,
      AppImages.sobhy,
      AppImages.tech21,
      AppImages.tech22,
      AppImages.tech23,
    ],
    'معمل تكنولوجيا': [
      AppImages.photo_gam,
      AppImages.sobhy,
      AppImages.tech21,
      AppImages.tech_2,
    ],
  };
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
      body: ListView.builder(
        itemCount: halls.keys.length,
        shrinkWrap: true, // في حالة وجوده داخل ScrollView
        physics: NeverScrollableScrollPhysics(), // منع التمرير الداخلي
        itemBuilder: (context, index) {
          final hallName = halls.keys.elementAt(index);
          final images = halls[hallName]!;

          return Card(
            color: AppColors.myBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageGalleryPage(
                      hallName: hallName,
                      images: images,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ImageGalleryPage extends StatefulWidget {
  final String hallName;
  final List<String> images;

  ImageGalleryPage({required this.hallName, required this.images});

  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  int currentIndex = 0;

  void _showNextImage() {
    if (currentIndex < widget.images.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _showPreviousImage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
                myWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          widget.images[currentIndex],
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showPreviousImage,
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
                          onPressed: _showNextImage,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              LinesImage(),
              CenterImage(nameImage: AppImages.map),
            ],
          ),
        ],
      ),
    );
  }
}
