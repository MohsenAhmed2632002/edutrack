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
                CenterImage(
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
// Launching lib\main.dart on Windows in debug mode...
// cmake -E tar: error: ZIP decompression failed (-5)
// CMake Deprecation Warning at C:/Users/sphinx_Mohsen/StudioProjects/edutrack/build/windows/x64/extracted/firebase_cpp_sdk_windows/CMakeLists.txt:17 (cmake_minimum_required):
//   Compatibility with CMake < 3.5 will be removed from a future version of
//   CMake.

//   Update the VERSION argument <min> value or use a ...<max> suffix to tell
//   CMake that the project does not need compatibility with older versions.
// 2


// .                                        \
//  *  History restored 

// PS C:\Users\sphinx_Mohsen\StudioProjects\edutrack> flutter build windows --release

// CMake Deprecation Warning at C:/Users/sphinx_Mohsen/StudioProjects/edutrack/build/windows/x64/extracted/firebase_cpp_sdk_windows/CMakeLists.txt:17 (cmake_minimum_required):
//   Compatibility with CMake < 3.5 will be removed from a future version of
//   CMake.

//   Update the VERSION argument <min> value or use a ...<max> suffix to tell
//   CMake that the project does not need compatibility with older versions.


// firebase_firestore.lib(f188d8a14517388912105d506d8c4564_absl_string_view.dir_Release_string_view.obj) : error LNK2019: unresolved external symbol __std_find_end_1 referenced in function "char const * __cdecl std::_Find_end_vectorized<char const ,char const >(char const * const,char const * const,char const * const,unsigned __int64)" (??$_Find_end_vectorized@$$CBD$$CBD@std@@YAPEBDQEBD00_K@Z) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_firestore.lib(1fe95d6838d9909cdf909015eeba18ea_re2.dir_Release_stringpiece.obj) : error LNK2001: unresolved external symbol __std_find_end_1 [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_firestore.lib(ec49100c7e8ab9d550bace2974e79db6_firestore_util.dir_Release_schedule.obj) : error LNK2019: unresolved external symbol _Cnd_timedwait_for_unchecked referenced in function "public: class firebase::firestore::util::Task * __cdecl firebase::firestore::util::Schedule::PopBlocking(void)" (?PopBlocking@Schedule@util@firestore@firebase@@QEAAPEAVTask@234@XZ) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_firestore.lib(060e08416dfaa8337f6db6660c103cb2_firestore_core.dir_Release_grpc_completion.obj) : error LNK2001: unresolved external symbol _Cnd_timedwait_for_unchecked [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_firestore.lib(764c577c30021320e8aabcd234c9fd5e_grpc.dir_Release_writing.obj) : error LNK2019: unresolved external symbol __std_min_8i referenced in function "auto __cdecl std::_Min_vectorized<__int64 const >(__int64 const * const,__int64 const * const)" (??$_Min_vectorized@$$CB_J@std@@YA?A_PQEB_J0@Z) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_firestore.lib(764c577c30021320e8aabcd234c9fd5e_grpc.dir_Release_tls_utils.obj) : error LNK2019: unresolved external symbol __std_find_last_trivial_1 referenced in function "char const * __cdecl std::_Find_last_vectorized<char const ,char>(char const * const,char const * const,char)" (??$_Find_last_vectorized@$$CBDD@std@@YAPEBDQEBD0D@Z) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_app.lib(9df1b499e9d93fa7bea97ae713d33ce7_flatbuffers.dir_Release_idl_parser.obj) : error LNK2001: unresolved external symbol __std_find_last_trivial_1 [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_app.lib(9df1b499e9d93fa7bea97ae713d33ce7_flatbuffers.dir_Release_util.obj) : error LNK2001: unresolved external symbol __std_find_last_trivial_1 [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_firestore.lib(1fe95d6838d9909cdf909015eeba18ea_re2.dir_Release_stringpiece.obj) : error LNK2019: unresolved external symbol __std_search_1 referenced in function "char const * __cdecl std::_Search_vectorized<char const ,char const >(char const * const,char const * const,char const * const,unsigned __int64)" (??$_Search_vectorized@$$CBD$$CBD@std@@YAPEBDQEBD00_K@Z) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_auth.lib(d48c2d5c2ee6ee6849b2a8e761eb596c_firebase_auth.dir_Release_error_codes.obj) : error LNK2001: unresolved external symbol __std_search_1 [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_app.lib(2869b77202c6adec44513cb2981d686e_leveldb.dir_Release_env_windows.obj) : error LNK2019: unresolved external symbol _Thrd_sleep_for referenced in function "void __cdecl std::this_thread::sleep_for<__int64,struct std::ratio<1,1000000> >(class std::chrono::duration<__int64,struct std::ratio<1,1000000> > const &)" (??$sleep_for@_JU?$ratio@$00$0PECEA@@std@@@this_thread@std@@YAXAEBV?$duration@_JU?$ratio@$00$0PECEA@@std@@@chrono@1@@Z) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_app.lib(9df1b499e9d93fa7bea97ae713d33ce7_flatbuffers.dir_Release_idl_parser.obj) : error LNK2019: unresolved external symbol __std_find_first_of_trivial_1 referenced in function "char const * __cdecl std::_Find_first_of_vectorized<char const ,char const >(char const * const,char const * const,char const * const,char const * const)" (??$_Find_first_of_vectorized@$$CBD$$CBD@std@@YAPEBDQEBD000@Z) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_app.lib(9df1b499e9d93fa7bea97ae713d33ce7_flatbuffers.dir_Release_idl_parser.obj) : error LNK2019: unresolved external symbol __std_remove_8 referenced in function "struct f_b_flatbuffers::StructDef * * __cdecl std::_Remove_vectorized<struct f_b_flatbuffers::StructDef *,struct f_b_flatbuffers::StructDef *>(struct f_b_flatbuffers::StructDef * * const,struct f_b_flatbuffers::StructDef * * const,struct f_b_flatbuffers::StructDef * const)" (??$_Remove_vectorized@PEAUStructDef@f_b_flatbuffers@@PEAU12@@std@@YAPEAPEAUStructDef@f_b_flatbuffers@@QEAPEAU12@0QEAU12@@Z) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// firebase_app.lib(9df1b499e9d93fa7bea97ae713d33ce7_flatbuffers.dir_Release_util.obj) : error LNK2019: unresolved external symbol __std_find_last_of_trivial_pos_1 referenced in function "unsigned __int64 __cdecl std::_Find_last_of_pos_vectorized<char,char>(char const * const,unsigned __int64,char const * const,unsigned __int64)" (??$_Find_last_of_pos_vectorized@DD@std@@YA_KQEBD_K01@Z) [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\Release\edutrack.exe : fatal error LNK1120: 9 unresolved externals [C:\Users\sphinx_Mohsen\StudioProjects\edutrack\build\windows\x64\runner\edutrack.vcxproj]
// Building Windows application...                                   263.7s
// Build process failed.
// PS C:\Users\sphinx_Mohsen\StudioProjects\edutrack> 