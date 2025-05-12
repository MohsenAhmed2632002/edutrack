import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Website extends StatelessWidget {
  const Website({super.key});

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
      // height: 550.h,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: "Website",
              child: Image.asset(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                AppImages.internet,
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
            Text(
              textAlign: TextAlign.center,
              "يمكنك زيارة الموقع الرسمي \nلجامعة عين شمس من هنا",
              style: getItalicTextStyle(
                context: context,
                color: AppColors.mywhite,
                fontSize: 30,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.myBlue,
                fixedSize: Size(
                  200,
                  50,
                ),
              ),
              onPressed: () async {
                final Uri url = Uri.parse("https://www.asu.edu.eg/ar");
                try {
                  await launchUrl(url, mode: LaunchMode.inAppWebView);
                } catch (e) {
                  print('حدث خطأ: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("تعذر فتح الموقع: $e")),
                  );
                }
              },
              child: Text(
                "اضغط هنا ",
                style: getArabBoldItalicTextStyle(
                  context: context,
                  color: AppColors.mywhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
