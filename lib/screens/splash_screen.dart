import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/app/utils/shared_preference_utility.dart';
import 'package:mindtech/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), _navigateUser);
  }

  Future<void> _navigateUser() async {
    bool isLogin = await SharedPreferencesUtility.getBool("isLogin");
    String userType = await SharedPreferencesUtility.getString("userType");
    if (isLogin) {
      if(userType == AppString.statusUserType){
        if (mounted) context.go(AppRoutes.bottomNav);
      }else{
        if (mounted) context.go(AppRoutes.expertBottomNav);
      }
    } else {
      if (mounted) context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColor.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(AppImage.logo),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSize.s30),
              child: CircularProgressIndicator(color: AppColor.primary,),
            )
          ],
        ),
      ),
    );
  }
}
