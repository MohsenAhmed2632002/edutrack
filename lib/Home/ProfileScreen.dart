import 'package:edutrack/core/Routing/Routes.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart'; // لو حابب تستخدم showErrorSnackBar مثلاً

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mywhite,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'الملف الشخصي',
          style: getArabBoldTextStyle(
            context: context,
            fontSize: 20.sp,
            color: AppColors.mywhite,
          ),
        ),
        leading: IconButton(
          color: AppColors.mywhite,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              EduTrackContainer(),
              LinesImage(),
              MyData(),
            ],
          ),
        ],
      ),
    );
  }
}

class MyData extends StatelessWidget {
  final LocalUserData _localUserData = LocalUserData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _localUserData.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ أثناء جلب البيانات'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('لا توجد بيانات مستخدم متاحة'));
        }

        final user = snapshot.data!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              FadeInDown(
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: AppColors.myBlue.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.mywhite,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              FadeInRight(
                child: InfoTile(title: 'الاسم', value: user.name ?? ''),
              ),
              FadeInLeft(
                child: InfoTile(
                    title: 'البريد الإلكتروني', value: user.email ?? ''),
              ),
              FadeInRight(
                child: InfoTile(
                    title: 'المجموعة الدراسية', value: user.study_Group ?? ''),
              ),
              FadeInLeft(
                child: InfoTile(
                    title: 'التخصص', value: user.specialization ?? 'لا يوجد'),
              ),
              FadeInRight(
                child:
                    InfoTile(title: 'رقم المستخدم', value: user.userId ?? ''),
              ),
              // لو تبغى تضيف مثلاً كلمة المرور المحفوظة مع تحذير ⚠️ (مش منصوح بإظهاره)
              FadeInLeft(
                child:
                    InfoTile(title: 'كلمة المرور', value: user.passWord ?? ''),
              ),

              FadeInUp(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.myBlue,
                  ),
                  onPressed: () async {
                    await FlutterLocalNotificationsPlugin().cancelAll();

                    await _localUserData.deleteUser().then(
                          (value) => Navigator.pushReplacementNamed(
                            context,
                            Routes.LoginPagRoute,
                          ),
                        );
                  },
                  child: Text(
                    "تسجيل خروج ",
                    style: getArabLightTextStyle(
                      context: context,
                      color: AppColors.mywhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InfoTile extends StatefulWidget {
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  State<InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  bool _isPasswordTileTapped = false; // متغير يتحكم بالتبديل

  @override
  Widget build(BuildContext context) {
    // نحدد هل هذا التايل خاص بكلمة المرور
    bool isPasswordTile = widget.title == 'كلمة المرور';

    return Card(
      color: AppColors.myBrightTurquoise,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: ListTile(
        onTap: isPasswordTile
            ? () {
                setState(() {
                  _isPasswordTileTapped = !_isPasswordTileTapped;
                });
              }
            : null,
        title: Text(
          widget.title,
          style: getArabBoldTextStyle(
            context: context,
            fontSize: 16.sp,
            color: AppColors.mywhite,
          ),
          textAlign: TextAlign.right,
        ),
        subtitle: Text(
          widget.value.isNotEmpty ? widget.value : 'غير متوفر',
          style: getArabBoldTextStyle(
            context: context,
            fontSize: 14.sp,
            color: isPasswordTile
                ? (_isPasswordTileTapped
                    ? AppColors.mywhite
                    : AppColors.myBrightTurquoise)
                : Colors.white,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
