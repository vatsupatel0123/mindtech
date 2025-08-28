import 'package:flutter/material.dart';

class AppColor {
  static Color primary = HexColor.fromHex("#21115c");
  static Color secondery = HexColor.fromHex("#39acff");
  static Color primary_dark = HexColor.fromHex("#770af9");

  static Color textfieldBorder = Color(0x1A111111);
  static Color divider = Color(0x1A111111);
  static Color cardIn = HexColor.fromHex("#ECFFF5");
  static Color cardOut = HexColor.fromHex("#FEF2F2");
  static Color gray = HexColor.fromHex("#c7c7c7");
  static Color grayDark = HexColor.fromHex("#a8a5a5");
  static Color grayBackground = HexColor.fromHex("#F1F3F6");
  static Color grayBorder = HexColor.fromHex("#E1E3EF");
  static Color accentColor = HexColor.fromHex("#013086");
  static Color accent = HexColor.fromHex("#0055FF");
  static Color line = HexColor.fromHex("#EEEEEE");
  static Color line2 = HexColor.fromHex("#a7a7a7");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color black = HexColor.fromHex("#111111");
  static Color blacklight = HexColor.fromHex("#333333");
  static Color red = HexColor.fromHex("#DC1C1C");
  static Color danger = HexColor.fromHex("#F00049");
  static Color green = HexColor.fromHex("#004225");
  static Color neptune_blue = HexColor.fromHex("#496275");
  static Color blue = HexColor.fromHex("#073CDF");
  static Color red_light = HexColor.fromHex("#D80101");
  static Color green_light = HexColor.fromHex("#016B3D");
  static Color majento = HexColor.fromHex("#008577");
  static Color transparent = HexColor.fromHex("#00000000");
  static Color grey_light = HexColor.fromHex("#E1E1E1");
  static Color grey = HexColor.fromHex("#5B5B64");
  static Color grey1 = HexColor.fromHex("#999999");
  static Color grey2 = HexColor.fromHex("#777777");
  static Color grey3 = HexColor.fromHex("#555555");
  static Color lightGrey = HexColor.fromHex("#D3D3D3");
  static Color success = HexColor.fromHex("#5CB816");
  static Color warning = HexColor.fromHex("#FFAD0F");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
