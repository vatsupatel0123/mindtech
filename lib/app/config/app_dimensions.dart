import 'package:flutter/material.dart';

class AppSize {
  // Small Sizes
  static const double s0 = 0;
  static const double s1 = 1.0;
  static const double s1_5 = 1.5;
  static const double s2 = 2.0;
  static const double s3 = 3.0;
  static const double s4 = 4.0;
  static const double s5 = 5.0;
  static const double s6 = 6.0;
  static const double s7 = 7.0;
  static const double s8 = 8.0;
  static const double s9 = 9.0;

  // Medium Sizes
  static const double s10 = 10.0;
  static const double s11 = 11.0;
  static const double s12 = 12.0;
  static const double s13 = 13.0;
  static const double s14 = 14.0;
  static const double s15 = 15.0;
  static const double s16 = 16.0;
  static const double s17 = 17.0;
  static const double s18 = 18.0;
  static const double s19 = 19.0;
  static const double s20 = 20.0;
  static const double s21 = 21.0;
  static const double s22 = 22.0;
  static const double s23 = 23.0;
  static const double s24 = 24.0;
  static const double s25 = 25.0;
  static const double s26 = 26.0;
  static const double s27 = 27.0;
  static const double s28 = 28.0;
  static const double s29 = 29.0;
  static const double s30 = 30.0;

  // Large Sizes
  static const double s40 = 40.0;
  static const double s50 = 50.0;
  static const double s60 = 60.0;
  static const double s70 = 70.0;
  static const double s80 = 80.0;
  static const double s90 = 90.0;
  static const double s100 = 100.0;
  static const double s120 = 120.0;
  static const double s150 = 150.0;
  static const double appbarSize = 40.0;
  static const double screenSpacing = 20.0;
}

// Screen Dimensions
class AppScreen {
  static Size size(BuildContext context) => MediaQuery.of(context).size;

  static double height(BuildContext context) => size(context).height;

  static double width(BuildContext context) => size(context).width;
}
