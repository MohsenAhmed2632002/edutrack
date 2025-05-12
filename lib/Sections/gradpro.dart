import 'package:animate_do/animate_do.dart';
import 'package:edutrack/core/Models/graduation_project_model.dart';
import 'package:edutrack/core/Server/fire_store.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';

class GraduationProject extends StatelessWidget {
  GraduationProject({super.key});
  final _localUserData = LocalUserData(); // تأكد أنك مستورده
  final fireSoterUser = FireSoterUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'مشروع التخرج',
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
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 600,
                  child: Image.asset(
                    AppImages.grad,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
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
                WhiteContainer(
                  myWidget: FutureBuilder(
                    future: _localUserData.getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                            child: Text('حدث خطأ أثناء جلب البيانات'));
                      }
                      final user = snapshot.data!;
                      if (user.study_Group == "الفرقة الثالثة") {
                        return FutureBuilder<List<GraduationProjectModel>>(
                          future: fireSoterUser
                              .getAllProjects(), // دالة تجلب المشاريع
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('حدث خطأ أثناء جلب المشاريع'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child:
                                      Text('لا يوجد مشاريع تخرج متاحة حالياً'));
                            }

                            final projects = snapshot.data!;

                            return ListView.builder(
                              shrinkWrap:
                                  true, // عشان احنا داخل SingleChildScrollView
                              physics:
                                  NeverScrollableScrollPhysics(), // عدم التمرير الداخلي
                              itemCount: projects.length,
                              itemBuilder: (context, index) {
                                final project = projects[index];
                                return Card(
                                  color: AppColors.myBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 3,
                                  child: ListTile(
                                    title: Text(
                                      project.projectName ?? '',
                                      textAlign: TextAlign.right,
                                      style: getArabBoldTextStyle(
                                        context: context,
                                        fontSize: 16.sp,
                                        color: AppColors.mywhite,
                                      ),
                                    ),
                                    subtitle: Text(
                                      project.projectIdea ?? '',
                                      textAlign: TextAlign.right,
                                      style: getArabLightTextStyle(
                                        context: context,
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                      if (user.study_Group == "الفرقة الرابعة") {
                        return BodyGraduation();
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BodyGraduation extends StatefulWidget {
  const BodyGraduation({super.key});

  @override
  State<BodyGraduation> createState() => _BodyGraduationState();
}

class _BodyGraduationState extends State<BodyGraduation>
    with TickerProviderStateMixin {
  final fireSoterUser = FireSoterUser();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectIdeaController = TextEditingController();
  final TextEditingController _supervisorNameController =
      TextEditingController();
  final TextEditingController _projectLinkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _currentIndex,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TabBar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            indicatorColor: AppColors.myBlue,
            labelColor: AppColors.myBlue,
            unselectedLabelColor: Colors.grey,
            labelStyle: getArabBoldTextStyle(
              context: context,
              fontSize: 16.sp,
              color: AppColors.myBlue,
            ),
            tabs: const [
              Tab(text: 'عرض المشاريع'),
              Tab(text: 'رفع مشروع'),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: _currentIndex == 0
                  ? _buildProjectsView()
                  : _buildUploadForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsView() {
    return FutureBuilder<List<GraduationProjectModel>>(
      key: const ValueKey('projectsView'),
      future: fireSoterUser.getAllProjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('حدث خطأ أثناء جلب المشاريع'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد مشاريع تخرج متاحة حالياً'));
        }

        final projects = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Card(
              color: AppColors.myBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                title: Text(
                  project.projectName ?? '',
                  textAlign: TextAlign.right,
                  style: getArabBoldTextStyle(
                    context: context,
                    fontSize: 16.sp,
                    color: AppColors.mywhite,
                  ),
                ),
                subtitle: Text(
                  project.projectIdea ?? '',
                  textAlign: TextAlign.right,
                  style: getArabLightTextStyle(
                    context: context,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUploadForm() {
    return SingleChildScrollView(
      key: const ValueKey('uploadForm'),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FadeInRight(
              child: Text(
                "مشروع التخرج",
                textAlign: TextAlign.center,
                style: getArabBoldItalicTextStyle(
                  context: context,
                  fontSize: 28.sp,
                  color: AppColors.myBlue,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _buildTextField(_projectNameController, "اسم مشروع التخرج",
                "برجاء ادخال اسم المشروع"),
            SizedBox(height: 15.h),
            _buildTextField(_projectIdeaController, "فكرة المشروع",
                "برجاء ادخال فكرة المشروع"),
            SizedBox(height: 15.h),
            _buildTextField(_projectLinkController, "لينك المشروع",
                "برجاء ادخال لينك المشروع"),
            SizedBox(height: 15.h),
            _buildTextField(
                _supervisorNameController, "الاشراف", "برجاء ادخال اسم المشرف"),
            SizedBox(height: 30.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.myBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _submitProject,
              child: Text(
                "تسليم",
                style: getArabBoldTextStyle(
                  context: context,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String validatorText) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Future<void> _submitProject() async {
    if (_formKey.currentState!.validate()) {
      await fireSoterUser.addGraduationProject(
        GraduationProjectModel(
          projectName: _projectNameController.text,
          projectIdea: _projectIdeaController.text,
          projectLink: _projectLinkController.text,
          supervisorName: _supervisorNameController.text,
          createdAt: DateTime.now(),
        ),
      );

      _projectNameController.clear();
      _projectIdeaController.clear();
      _projectLinkController.clear();
      _supervisorNameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تسليم المشروع بنجاح',
            style: getArabLightTextStyle(
              context: context,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'حسناً',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }
}
