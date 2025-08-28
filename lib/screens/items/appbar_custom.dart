import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/config/appnetwork_image.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    String fullName = userProvider.name ?? '';
    String userType = userProvider.userType ?? '';
    String photo = userProvider.photo ?? '';
    return AppBar(
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: AppSize.s25,
          top: AppSize.s5,
          bottom: AppSize.s5,
        ),
        child: GestureDetector(
          onTap: (){
            if(userType==AppString.statusUserType){
              context.push(AppRoutes.editProfile);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.gray),
              borderRadius: BorderRadius.circular(60)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: AppNetworkImage(imageUrl: photo)
            ),
          ),
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userType==AppString.statusUserType?AppString.hey_buddy:AppString.welcome,
            style: AppTextStyle.h5.copyWith(
              fontSize: AppSize.s12,
              color: AppColor.grayDark,
            ),
          ),
          Text(fullName, style: AppTextStyle.h2),
        ],
      ),
      centerTitle: false,
      actions: [
        if(userType==AppString.statusUserType)GestureDetector(
          onTap: (){
            context.push(AppRoutes.emergency);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s15,vertical: AppSize.s2),
            margin: EdgeInsets.only(right: AppSize.s5),
            decoration: BoxDecoration(
              color: AppColor.danger,
              borderRadius: BorderRadius.circular(AppSize.s10)
            ),
            child: Text("SOS",style: AppTextStyle.h3.copyWith(color: AppColor.white,fontSize: AppSize.s12),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSize.s15),
          child: GestureDetector(
            onTap: () {
              context.push(AppRoutes.notification);
            },
            child: Icon(Icons.notifications, color: AppColor.black),
          ),
        ),
      ],
      elevation: AppSize.s1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
