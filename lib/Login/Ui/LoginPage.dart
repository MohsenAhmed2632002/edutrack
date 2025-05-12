import 'package:dropdown_search/dropdown_search.dart';
import 'package:edutrack/Login/cubit/login_cubit.dart';
import 'package:edutrack/core/Routing/Routes.dart';
import 'package:edutrack/core/Routing/app_regex.dart';
import 'package:edutrack/core/Server/NotifyServer.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/Server/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final LocalUserData _localUserData = LocalUserData();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // _localUserData.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                EduTrackContainer(),
                LinesImage(),
                BlocProvider(
                  create: (context) => LoginCubit(),
                  child: WhiteContainer(
                    myWidget: MyPage(
                      usernameController: _usernameController,
                      emailController: _emailController,
                      passWordController: _passWordController,
                      formKey: _formKey,
                    ),
                  ),
                ),
                CenterImage(nameImage: AppImages.hand),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyPage extends StatefulWidget {
  MyPage({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passWordController,
  });
  final GlobalKey<FormState> formKey;

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passWordController;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final dropDownKey = GlobalKey<DropdownSearchState>();
  String selectedGrade = "";
  String selectedSpecialization = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                textAlign: TextAlign.center,
                "أهلا بكم في ",
                style: getArabLightTextStyle(
                  context: context,
                  fontSize: 45,
                  color: AppColors.myBrightTurquoise,
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                AppStrings.appName,
                style: getItalicTextStyle(
                  context: context,
                  fontSize: 50,
                  color: AppColors.myBlue,
                ),
              ),
              CircleAvatar(
                backgroundColor: AppColors.myBlue,
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 75,
                  color: AppColors.mywhite,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: widget.usernameController,
                  textAlign: TextAlign.right,
                  validator: (value) {
                    // usernameController.text == "admin"
                    if (value == null ||
                        value.isEmpty ||
                        AppRegex.hasMinLength(value)) {
                      return "برجاء ادخال الاسم بشكل سليم ";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "اسم المستخدم ",
                    label: Text(
                      ".....برجاء ادخال اسم المستخدم ",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: widget.emailController,
                  textAlign: TextAlign.right,
                  validator: (value) {
                    // usernameController.text == "admin"
                    if (value == null || value.isEmpty) {
                      return "برجاء ادخال الايميل بشكل صحيح";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "الايميل",
                    label: Text(
                      ".....برجاء ادخال الايميل",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: widget.passWordController,
                  textAlign: TextAlign.right,
                  validator: (value) {
                    // usernameController.text == "admin"
                    if (value == null ||
                        value.isEmpty ||
                        AppRegex.isPasswordValid(value)) {
                      return "برجاء ادخال كلمة المرور بشكل صحيح";
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "كلمة المرور ",
                    label: Text(
                      ".....برجاء ادخال كلمة المرور",
                      style: getArabLightTextStyle(
                        context: context,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                  // mode: Mode.form,
                  key: dropDownKey,
                  selectedItem: selectedGrade,
                  items: (filter, infiniteScrollProps) => [
                    "الفرقة الأولى",
                    "الفرقة الثانية",
                    "الفرقة الثالثة",
                    "الفرقة الرابعة",
                  ],
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'اختر الفرقة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    constraints: BoxConstraints.tightFor(height: 270.h),
                    showSelectedItems: true,
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "ابحث عن الفرقة",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedGrade = value!;
                      // نمسح الاختيار السابق إذا تغيرت الفرقة
                      if (value != "الفرقة الثالثة" &&
                          value != "الفرقة الرابعة") {
                        selectedSpecialization = "اختر التخصص";
                      }
                    });
                  },
                ),
              ),
              // نمسح الاختيار السابق إذا تغيرت الفرقة
              if (selectedGrade == "الفرقة الثالثة" ||
                  selectedGrade == "الفرقة الرابعة")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownSearch<String>(
                    // mode: Mode.dialog,
                    selectedItem: selectedSpecialization,
                    items: (filter, loadProps) => [
                      "معلم ",
                      " أخصائي",
                    ],
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: 'اختر التخصص',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      constraints: BoxConstraints.tightFor(height: 200.h),
                      showSelectedItems: true,
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: "ابحث عن التخصص",
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedSpecialization = value!;
                      });
                    },
                  ),
                ),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.myBlue,
                    ),
                    onPressed: () {
                      if (widget.formKey.currentState!.validate()) {
                        try {
                          //TODO
                          context.read<LoginCubit>().loginUser(
                                email: widget.emailController.text,
                                password: widget.passWordController.text,
                                name: widget.usernameController.text,
                                context: context,
                                study_Group: selectedGrade,
                                specialization: selectedSpecialization,
                              );
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "فشل تسجيل الدخول: في اول مره يجب تشغيل الانترنت ",
                                style: getArabLightTextStyle(
                                  context: context,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'حسناً',
                                textColor: Colors.white,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: state is LoginLoading
                        ? CircularProgressIndicator(color: AppColors.mywhite)
                        : Text(
                            "تسجيل دخول ",
                            style: getArabLightTextStyle(
                              context: context,
                              color: AppColors.mywhite,
                            ),
                          ),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.SginUpRoute,
                  );
                },
                child: Text(
                  "انشاء حساب",
                  style: getArabLightTextStyle(
                    context: context,
                    color: AppColors.myBlue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
