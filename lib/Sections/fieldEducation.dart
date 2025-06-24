import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Fieldeducation extends StatelessWidget {
  Fieldeducation({super.key});

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
                EduTrackContainer(),
                LinesImage(),
                WhiteContainer(
                  myWidget: BodyFiekdEducation(),
                ),
                CenterImageFieldeducation(
                  nameImage: AppImages.light_book,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BodyFiekdEducation extends StatelessWidget {
  const BodyFiekdEducation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 550.h,
            child: SfPdfViewer.asset("assets/table/file2.pdf"),
          )
        ],
      ),
    );
  }
}

class CenterImageFieldeducation extends StatelessWidget {
  final String nameImage;
  const CenterImageFieldeducation({
    required this.nameImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 500.h,
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
