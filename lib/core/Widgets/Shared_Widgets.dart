import 'package:animate_do/animate_do.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EduTrackContainer extends StatelessWidget {
  EduTrackContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        AppImages.edu_track,
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
      child: Image.asset(
        AppImages.lines,
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

class RowNameAndImage extends StatelessWidget {
  final String myImage;
  final Widget myWidget;
  const RowNameAndImage({
    super.key,
    required this.myImage,
    required this.myWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            height: 200.h,
            width: 150.w,
            myImage,
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
          myWidget
        ],
      ),
    );
  }
}

class HomeRowNameAndImage extends StatelessWidget {
  final String myImage;
  final Widget myWidget;
  const HomeRowNameAndImage({
    super.key,
    required this.myImage,
    required this.myWidget,
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
          FadeInDown(
            child: Image.asset(
              height: 200.h,
              width: 150.w,
              myImage,
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
          myWidget
        ],
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: myWidget,
      ),
    );
  }
}

class SimpleMore extends StatelessWidget {
  final String text;
  final String myImage;
  final Color backGroundColor;
  SimpleMore({
    super.key,
    required this.text,
    required this.myImage,
    required this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            height: 150.h,
            width: 150.w,
            decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            bottom: 40,
            height: 100.h,
            width: 100.w,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.mywhite,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            // left: 10,
            // right: 10,
            bottom: 10,
            height: 150.h,
            width: 150.w,

            child: Image.asset(
              // height: 200.h,
              // width: 100.w,
              myImage,
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
          Text(
            textAlign: TextAlign.center,
            text,
            style: getArabLightTextStyle(
              context: context,
              color: AppColors.mywhite,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: getArabLightTextStyle(
          context: context,
          color: AppColors.mywhite,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
