import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';

class Regulations extends StatelessWidget {
  const Regulations({super.key});

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
              regulationsImage(),
            ],
          ),
        ],
      ),
    );
  }
}

class regulationsImage extends StatelessWidget {
  const regulationsImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 550,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Hero(
            tag: "regulations",
            child: Image.asset(
              height: 200.h,
              width: 200.w,
              AppImages.regulations,
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
                "اللائحة",
                style: getArabBoldItalicTextStyle(
                  context: context,
                  fontSize: 20,
                  color: AppColors.myBlue,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                "الخاصة بالكلية",
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
  const WhiteContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      height: 650.h,
      child: Container(
        // height: 1100.h,
        decoration: BoxDecoration(
          color: AppColors.mywhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              textAlign: TextAlign.center,
              AppStrings.Mydta,
              style: getItalicTextStyle(
                context: context,
                fontSize: 16,
                color: AppColors.myBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EduTrackContainer extends StatelessWidget {
  const EduTrackContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: AppColors.mywhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Image(
        fit: BoxFit.fill,
        image: AssetImage(
          AppImages.edu_track,
        ),
      ),
    );
  }
}
