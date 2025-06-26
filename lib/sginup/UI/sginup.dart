// ✅ SginUpPage محسّنة مثل LoginPage
import 'package:dropdown_search/dropdown_search.dart';
import 'package:edutrack/sginup/cubit/sginup_cubit.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Routing/app_regex.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SginUpPage extends StatefulWidget {
  const SginUpPage({super.key});

  @override
  State<SginUpPage> createState() => _SginUpPageState();
}

class _SginUpPageState extends State<SginUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? selectedGrade;
  String? selectedSpecialization;
  bool _obscurePassword = true;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                EduTrackContainer(),
                const LinesImage(),
                _buildForm(context),
                const CenterImage(nameImage: AppImages.hand),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocBuilder<SginupCubit, SginupState>(
      builder: (context, state) {
        return WhiteContainer(
          myWidget: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("إنشاء حساب",
                        style: getArabLightTextStyle(
                            context: context,
                            fontSize: 40,
                            color: AppColors.myBrightTurquoise)),
                    CircleAvatar(
                        backgroundColor: AppColors.myBlue,
                        radius: 50,
                        child: Icon(Icons.person,
                            size: 75, color: AppColors.mywhite)),
                    const SizedBox(height: 10),
                    _buildTextField(_usernameController, 'اسم المستخدم',
                        AppRegex.hasMinLength, 'برجاء ادخال الاسم بشكل سليم'),
                    _buildTextField(_emailController, 'الايميل',
                        AppRegex.isEmailValid, 'برجاء ادخال الايميل بشكل صحيح'),
                    _buildPasswordField(),
                    _buildGradeDropdown(),
                    if (selectedGrade == "الفرقة الثالثة" ||
                        selectedGrade == "الفرقة الرابعة")
                      _buildSpecializationDropdown(),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.myBlue),
                      onPressed: state is SginUpLoading ? null : _submit,
                      child: state is SginUpLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("إنشاء حساب",
                              style: getArabLightTextStyle(
                                  context: context, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      bool Function(String) validator, String errorMessage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.right,
          validator: (value) =>
              value == null || value.isEmpty || !validator(value)
                  ? errorMessage
                  : null,
          decoration: InputDecoration(
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    final password = _passwordController.text;
    final passwordCriteria = <Map<String, dynamic>>[
      {
        'label': 'حرف كبير (A-Z)',
        'isMet': AppRegex.hasUpperCase(password),
      },
      {
        'label': 'حرف صغير (a-z)',
        'isMet': AppRegex.hasLowerCase(password),
      },
      {
        'label': 'رقم (0-9)',
        'isMet': AppRegex.hasNumber(password),
      },
      {
        'label': 'رمز خاص (@, #, %, !, ...)',
        'isMet': AppRegex.hasSpecialCharacter(password),
      },
      {
        'label': 'الحد الأدنى 8 أحرف',
        'isMet': password.length >= 8,
      }
    ];

    final isPasswordValid = AppRegex.isPasswordValid(password);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textAlign: TextAlign.right,
              onChanged: (_) => setState(() {}),
              validator: (value) =>
                  value == null || value.isEmpty || !isPasswordValid
                      ? 'برجاء ادخال كلمة المرور بشكل صحيح'
                      : null,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (password.isNotEmpty && !isPasswordValid)
              ...passwordCriteria.map((item) {
                final bool met = item['isMet'];
                final String label = item['label'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Icon(
                        met ? Icons.check_circle : Icons.cancel,
                        size: 18,
                        color: met ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color: met ? Colors.green : Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownSearch<String>(
          selectedItem: selectedGrade,
          items: (filter, _) async => [
            "الفرقة الأولى",
            "الفرقة الثانية",
            "الفرقة الثالثة",
            "الفرقة الرابعة"
          ],
          onChanged: (value) => setState(() {
            selectedGrade = value;
            if (value != "الفرقة الثالثة" && value != "الفرقة الرابعة") {
              selectedSpecialization = null;
            }
          }),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            showSearchBox: true,
            constraints: BoxConstraints.tightFor(height: 270.h),
            searchFieldProps: TextFieldProps(
              decoration: const InputDecoration(
                  hintText: "ابحث عن الفرقة", prefixIcon: Icon(Icons.search)),
            ),
          ),
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
        ),
      ),
    );
  }

  Widget _buildSpecializationDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownSearch<String>(
          selectedItem: selectedSpecialization,
          items: (filter, _) async => ["معلم", "أخصائي"],
          onChanged: (value) => setState(() => selectedSpecialization = value),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            showSearchBox: true,
            constraints: BoxConstraints.tightFor(height: 200.h),
            searchFieldProps: TextFieldProps(
              decoration: const InputDecoration(
                  hintText: "ابحث عن التخصص", prefixIcon: Icon(Icons.search)),
            ),
          ),
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
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    if (selectedGrade == null) {
      _showError('رجاءً اختر الفرقة');
      return;
    }
    if ((selectedGrade == "الفرقة الثالثة" ||
            selectedGrade == "الفرقة الرابعة") &&
        selectedSpecialization == null) {
      _showError('رجاءً اختر التخصص');
      return;
    }

    final user = UserModel(
      name: _usernameController.text,
      email: _emailController.text,
      passWord: _passwordController.text,
      specialization: selectedSpecialization ?? '',
      study_Group: selectedGrade!,
      userId: '',
    );

    context.read<SginupCubit>().sginUp(
          context: context,
          email: user.email,
          password: user.passWord,
          name: user.name,
          study_Group: user.study_Group,
          specialization: user.specialization,
          myUser: user,
        );
  }
}
