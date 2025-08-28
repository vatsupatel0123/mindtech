import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/shared_preference_utility.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/providers/user_provider.dart';
import 'package:mindtech/screens/items/appbar_custom.dart';
import 'package:provider/provider.dart';

class MyaccountScreen extends StatefulWidget {
  const MyaccountScreen({super.key});

  @override
  State<MyaccountScreen> createState() => _MyaccountScreenState();
}

class _MyaccountScreenState extends State<MyaccountScreen> {
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context,listen: true);
    return Scaffold(
      appBar: AppBarCustom(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.screenSpacing,
            vertical: AppSize.screenSpacing,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(userProvider.userType ==AppString.statusUserType)SettingsOption(title: "Edit Your Profile", onTap: () {
                      context.push(AppRoutes.editProfile);
                    }),
                    SettingsOption(title: "Change Password", onTap: () {
                      context.push(AppRoutes.changePassword);
                    }),
                    SettingsOption(title: "Privacy Policy", onTap: () {
                      context.push(AppRoutes.privacyPolicy);
                    }),
                    SettingsOption(title: "Terms & Conditions", onTap: () {
                      context.push(AppRoutes.termsAndConditions);
                    }),
                  ],
                ),
              ),
              AppButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: AppColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        title: Text('Logout', style: AppTextStyle.h2),
                        titlePadding: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s10),
                        contentPadding: EdgeInsets.only(left: AppSize.s20,right: AppSize.s20,bottom: AppSize.s20),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: AppTextStyle.h4,
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  onTap: () => Navigator.of(context).pop(),
                                  buttonText: 'Cancel',
                                  height: 40,
                                  buttonTextFontSize: AppSize.s14,
                                  borderColor: AppColor.primary,
                                  textColor: AppColor.primary,
                                  buttonColor: AppColor.white,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: AppButton(
                                  onTap: () async {
                                    await SharedPreferencesUtility.clearSharedPrefrences();
                                    context.go(AppRoutes.login);
                                  },
                                  buttonText: 'Logout',
                                  height: 40,
                                  buttonColor: AppColor.red,
                                  borderColor: AppColor.red,
                                  buttonTextFontSize: AppSize.s14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                buttonText: AppString.logout,
                buttonColor: AppColor.red,
                borderColor: AppColor.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsOption({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSize.s16),
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s12,
          vertical: AppSize.s14,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100], // Light gray background
          border: Border.all(color: AppColor.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(AppSize.s10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyle.h4),
            Icon(Icons.arrow_forward_ios, size: 18, color: AppColor.black),
          ],
        ),
      ),
    );
  }
}
