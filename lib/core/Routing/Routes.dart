import 'package:edutrack/Home/CourseOverviewPage.dart';
import 'package:edutrack/Home/HomePage.dart';
import 'package:edutrack/Home/ProfileScreen.dart';
import 'package:edutrack/Login/Ui/LoginPage.dart';
import 'package:edutrack/More/AskedQuestions.dart';
import 'package:edutrack/More/Regulations.dart';
import 'package:edutrack/More/website.dart';
import 'package:edutrack/Sections/Lecture.dart';
import 'package:edutrack/Sections/decisions.dart';
import 'package:edutrack/Sections/fieldEducation.dart';
import 'package:edutrack/Sections/gradpro.dart';
import 'package:edutrack/More/howtoget.dart';
import 'package:edutrack/Sections/information.dart';
import 'package:edutrack/Sections/sction.dart';
import 'package:edutrack/sginup/UI/sginup.dart';
import 'package:flutter/material.dart';

import '../../splash_screen.dart';

class Routes {
  // static const String CourseOverviewPageRoute = "/CourseOverviewPage";
  static const String LoginPagRoute = "/LoginPage";

  static const String AskedQuestionsRoute = "/AskedQuestionsPage";
  static const String loginRoute = "/loginRoute";

  static const String HomePageRoute = "/HomePageRoute";

  static const String splashRoute = "/splashRoute";

  static const String RegulationsRoute = "/RegulationsPage";
  static const String WebsiteRoute = "/WebsitePage";
  static const String GraduationProjectRoute = "/GraduationProjectPage";
  static const String InformationAboutRoute = "/InformationAboutpage";

  static const String HowToGetRoute = "/HowToGetRoutepage";
  static const String decisionsRoute = "/decisionspage";

  static const String SginUpRoute = "/SginUpPage";

  static const String FieldeducationRoute = "/FieldeducationPage";
// SectionSchedulePage

  static const String LectureSchedulePage = "/LectureSchedulePage";
  static const String SectionSchedulePage = "/  SectionSchedulePage";
  static const String ProfileScreen = "/  ProfileScreen ";
}

class RoutesGenerator {
  static Route<dynamic>? getRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
      case Routes.LoginPagRoute:
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case Routes.SginUpRoute:
        return MaterialPageRoute(
          builder: (context) => SginUpPage(),
        );
      // case Routes.CourseOverviewPageRoute:
      // return MaterialPageRoute(
      // builder: (context) => CourseOverviewPage(),
      // );
      case Routes.HomePageRoute:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );

      case Routes.AskedQuestionsRoute:
        return MaterialPageRoute(
          builder: (context) => AskedQuestions(),
        );
      case Routes.WebsiteRoute:
        return MaterialPageRoute(
          builder: (context) => Website(),
        );
      case Routes.RegulationsRoute:
        return MaterialPageRoute(
          builder: (context) => Regulations(),
        );
      case Routes.GraduationProjectRoute:
        return MaterialPageRoute(
          builder: (context) => GraduationProject(),
        );
      case Routes.InformationAboutRoute:
        return MaterialPageRoute(
          builder: (context) => InformationAbout(),
        );
      case Routes.HowToGetRoute:
        return MaterialPageRoute(
          builder: (context) => HowToGet(),
        );

      case Routes.decisionsRoute:
        return MaterialPageRoute(
          builder: (context) => DecisionsPage(),
        );

      case Routes.FieldeducationRoute:
        return MaterialPageRoute(
          builder: (context) => Fieldeducation(),
        );

      case Routes.LectureSchedulePage:
        return MaterialPageRoute(
          builder: (context) => LectureSchedulePage(),
        );

      case Routes.SectionSchedulePage:
        return MaterialPageRoute(
          builder: (context) => SectionSchedulePage(),
        );
      case Routes.ProfileScreen:
        return MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        );

      default:
        return null;
    }
  }
}

// class ErorPage extends StatelessWidget {
//   const ErorPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("erorr page"),
//       ),
//     );
//   }
// }
