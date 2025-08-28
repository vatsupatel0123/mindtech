import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';

class AppFontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

class AppTextStyle {
  static const String fontFamily = "Figtree";

  static TextStyle h1 = TextStyle(
    fontSize: AppSize.s30,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    color: AppColor.black,
  );

  static TextStyle h2 = TextStyle(
    fontSize: AppSize.s20,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    color: AppColor.black,
  );

  static TextStyle h3 = TextStyle(
    fontSize: AppSize.s16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    color: AppColor.black,
  );

  static TextStyle h4 = TextStyle(
    fontSize: AppSize.s16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: AppColor.blacklight,
  );

  static TextStyle h5 = TextStyle(
    fontSize: AppSize.s14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: AppColor.black,
  );

  static TextStyle label = TextStyle(
    fontSize: AppSize.s16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle hint = TextStyle(
    fontSize: AppSize.s14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: AppColor.blacklight
  );

  static TextStyle error = TextStyle(
    fontSize: AppSize.s14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: Colors.red,
  );

  static TextStyle button = TextStyle(
    fontSize: AppSize.s16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

}
