import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final void Function()? onTap;
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final BorderRadiusGeometry? borderRadius;
  final String? buttonText;
  final double? buttonTextFontSize;
  final TextAlign? buttonTextAlign;
  final FontWeight? buttonTextFontWeight;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height,
    this.width,
    this.alignment,
    this.margin,
    this.padding,
    this.buttonColor,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.buttonTextFontSize,
    this.buttonTextAlign,
    this.buttonTextFontWeight,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (height == null && width == null) {
      return ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(AppSize.s8),
            side: BorderSide(color: borderColor ?? AppColor.primary),
          ),
          disabledBackgroundColor: buttonColor ?? AppColor.primary,
        ),
        child: Container(
          height: height,
          width: width,
          alignment: alignment ?? Alignment.center,
          margin: margin ?? EdgeInsets.zero,
          child: isLoading
              ? SizedBox(
                height: 25,
                width: 25,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2,)))
              : Text(
            buttonText ?? '',
            style: AppTextStyle.button.copyWith(
              color: textColor,
              fontSize: buttonTextFontSize,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          height: height,
          width: width,
          alignment: alignment ?? Alignment.center,
          margin: margin ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: buttonColor ?? AppColor.primary,
            borderRadius: borderRadius ?? BorderRadius.circular(AppSize.s8),
            border: Border.all(color: borderColor ?? (buttonColor ?? AppColor.transparent))
          ),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Text(
            buttonText ?? '',
            style: AppTextStyle.button.copyWith(
              color: textColor,
              fontSize: buttonTextFontSize,
            ),
          ),
        ),
      );
    }
  }
}
