import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_text_styles.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: AppColor.primary,
    primaryColorLight: AppColor.primary,
    scaffoldBackgroundColor: AppColor.white,
    splashColor: AppColor.transparent,
    unselectedWidgetColor: Colors.black,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    cardTheme: CardTheme(
      color: AppColor.white,
      shadowColor: AppColor.grey2,
      elevation: AppSize.s2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      surfaceTintColor: AppColor.white,
    ),
    appBarTheme: AppBarTheme(
      color: AppColor.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColor.white,
        statusBarIconBrightness: Brightness.dark
      ),
      titleTextStyle: AppTextStyle.h2,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    primarySwatch: Colors.blue,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.white, // Change color globally
      circularTrackColor: Colors.blue, // Track color
    ),
    dividerTheme: DividerThemeData(
      color: AppColor.divider,
      thickness: 1,
    ),
    dialogBackgroundColor: AppColor.white,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.white,
      contentPadding: const EdgeInsets.all(15),
      alignLabelWithHint: false,
      hintStyle: AppTextStyle.hint,
      labelStyle: AppTextStyle.label,
      errorStyle: AppTextStyle.error,
      suffixIconColor: AppColor.grey,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle: AppTextStyle.h3,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.textfieldBorder,
          width: AppSize.s1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.textfieldBorder,
          width: AppSize.s1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.textfieldBorder,
          width: AppSize.s1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.textfieldBorder,
          width: AppSize.s1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.textfieldBorder,
          width: AppSize.s1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
    ),
  );
}
