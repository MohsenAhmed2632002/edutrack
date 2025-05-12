import 'package:edutrack/core/Routing/Routes.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_file_view/flutter_file_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CourseOverviewPage extends StatelessWidget {
  const CourseOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myBlue,
      body: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              EduTrackContainer(),
              LinesImage(),
              WhiteContainer(
                myWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
        

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.myBlue,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.HomePageRoute,
                        );
                      },
                      child: Text(
                        "ابداء الان ",
                        style: getArabBoldItalicTextStyle(
                          context: context,
                          color: AppColors.mywhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RowNameAndImage(
                myImage: AppImages.book1,
                myWidget: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "نبذة عن",
                      style: getArabBoldItalicTextStyle(
                        context: context,
                        fontSize: 30,
                        color: AppColors.myBrightTurquoise,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "المقررات",
                      style: getArabBoldItalicTextStyle(
                        context: context,
                        fontSize: 30,
                        color: AppColors.myBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CoursesImage extends StatelessWidget {
  const CoursesImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 580,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            height: 200.h,
            width: 150.w,
            image: AssetImage(
              AppImages.book1,
            ),
          ),
          Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                "نبذة عن",
                style: getArabBoldItalicTextStyle(
                  context: context,
                  fontSize: 30,
                  color: AppColors.myBrightTurquoise,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                "المقررات",
                style: getArabBoldItalicTextStyle(
                  context: context,
                  fontSize: 30,
                  color: AppColors.myBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
