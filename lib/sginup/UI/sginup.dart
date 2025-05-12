import 'package:dropdown_search/dropdown_search.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Routing/Routes.dart';
import 'package:edutrack/core/Routing/app_regex.dart';
import 'package:edutrack/core/Server/NotifyServer.dart';
import 'package:edutrack/core/repo/fire_base_auth.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/Server/sharedpref.dart';
import 'package:edutrack/sginup/cubit/sginup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SginUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPassWordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SginUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SginupCubit(),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   leading: IconButton(
        //     color: AppColors.mywhite,
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  EduTrackContainer(),
                  LinesImage(),
                  BlocConsumer<SginupCubit, SginupState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return WhiteContainer(
                        myWidget: MyPage(
                          usernameController: _usernameController,
                          userEmailController: _userEmailController,
                          userPassWordController: _userPassWordController,
                          formKey: _formKey,
                        ),
                      );
                    },
                  ),
                  CenterImage(nameImage: AppImages.hand),
                ],
              ),
            ],
          ),
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
    required this.userEmailController,
    required this.userPassWordController,
  });
  final GlobalKey<FormState> formKey;

  final TextEditingController usernameController;
  final TextEditingController userEmailController;
  final TextEditingController userPassWordController;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final dropDownKey = GlobalKey<DropdownSearchState>();
  String selectedGrade = "";
  String selectedSpecialization = "";
  final _auth = FireBaseAuth();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.myBlue,
              radius: 50,
              child: Icon(
                Icons.person,
                size: 75,
                color: AppColors.mywhite,
              ),
            ),
            TextFormField(
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
            TextFormField(
              controller: widget.userEmailController,
              textAlign: TextAlign.right,
              validator: (value) {
                // usernameController.text == "admin"
                if (value == null || value.isEmpty) {
                  return "برجاء ادخال الايميل بشكل صحيح ";
                }
              },
              decoration: InputDecoration(
                hintText: "الايميل ",
                label: Text(
                  ".....برجاء ادخال الايميل ",
                ),
              ),
            ),
            TextFormField(
              controller: widget.userPassWordController,
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
                hintText: "اسم كلمة المرور  ",
                label: Text(
                  ".....برجاء ادخال كلمة المرور  ",
                ),
              ),
            ),
            DropdownSearch<String>(
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
                  if (value != "الفرقة الثالثة" && value != "الفرقة الرابعة") {
                    selectedSpecialization = "اختر التخصص";
                  }
                });
              },
            ), // نمسح الاختيار السابق إذا تغيرت الفرقة
            if (selectedGrade == "الفرقة الثالثة" ||
                selectedGrade == "الفرقة الرابعة")
              DropdownSearch<String>(
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
            BlocBuilder<SginupCubit, SginupState>(
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.myBlue,
                  ),
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      try {
                        final userModel = UserModel(
                          name: widget.usernameController.text,
                          email: widget.userEmailController.text,
                          passWord: widget.userPassWordController.text,
                          specialization: selectedSpecialization,
                          study_Group: selectedGrade,
                          userId: "1",
                        );
                        context.read<SginupCubit>().sginUp(
                              context: context,
                              myUser: userModel,
                              specialization: selectedSpecialization,
                              study_Group: selectedGrade,
                              email: widget.userEmailController.text,
                              password: widget.userPassWordController.text,
                              name: widget.usernameController.text,
                            );
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "$e",
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
                  child: state is SginUpLoading
                      ? CircularProgressIndicator(color: AppColors.mywhite)
                      : Text(
                          "انشاء حساب",
                          style: getArabLightTextStyle(
                            context: context,
                            color: AppColors.mywhite,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
