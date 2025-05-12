import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/main.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'core/Routing/Routes.dart';

class SplashView extends StatefulWidget {
  SplashView._intarnal();
  static final SplashView _instance = SplashView._intarnal();
  factory SplashView() => _instance;
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  void initState() {
    super.initState();
    Future.delayed(
      Duration(
        seconds: 3,
      ),
      () async {
        print("Splash View userisLoggedin: ${userisLoggedin}");
        return Navigator.pushReplacementNamed(
          context,
          await checkUserIsLoggedIn()
              ? Routes.HomePageRoute
              : Routes.LoginPagRoute,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Login View userisLoggedin2: $userisLoggedin");

    return Scaffold(
      body: Center(
        child: FadeInUpBig(
          child: const Image(
            image: AssetImage(
              AppImages.main_icon,
            ),
          ),
        ),
      ),
    );
  }
}
