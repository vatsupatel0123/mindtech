import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_text_styles.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? text, label, hinttext, textlabel;
  final int? maxlines;

  final Widget? suffixIcon, prefixIcon;
  final bool? obscureText, enabled, autofocus, isFormGujarati;
  final EdgeInsets? contentPadding;
  final Color? textboxfillcolor;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final int? maxLength;
  final TextInputType? inputtype;
  final Function()? onTap;
  final TextCapitalization? textCapitalization;
  final void Function(String?)? onSaved;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? autofillHitns;
  final bool? readonly;

  const AppTextFormField(this.text, this.textEditingController,
      {super.key,
      this.textlabel,
      this.enabled,
      this.maxLength,
      this.inputtype,
      this.textCapitalization,
      this.suffixIcon,
      this.prefixIcon,
      this.obscureText,
      this.contentPadding,
      this.borderSide,
      this.hinttext,
      this.onSaved,
      this.validator,
      this.onChanged,
      this.borderRadius,
      this.label,
      this.onTap,
      this.maxlines,
      this.autofocus,
      this.inputFormatters,
      this.textboxfillcolor,
      this.autofillHitns,
      this.readonly,
      this.isFormGujarati});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          textCapitalization: textCapitalization != null
              ? textCapitalization!
              : TextCapitalization.none,
          autofillHints: [autofillHitns ?? ""],
          initialValue: null,
          enableInteractiveSelection: true,
          autofocus: autofocus ?? false,
          enabled: enabled ?? true,
          controller: textEditingController,
          obscureText: obscureText == null ? false : obscureText!,
          maxLines: maxlines ?? 1,
          cursorColor: AppColor.primary,
          keyboardType: inputtype ?? TextInputType.text,
          inputFormatters: inputFormatters,
          onTap: onTap,
          onSaved: onSaved,
          onChanged: onChanged,
          maxLength: maxLength,
          readOnly: readonly ?? false,
          style: AppTextStyle.h4,
          validator: validator == null
              ? (val) {
                  if (val.toString().trim().isEmpty) {
                    return "Please enter ${text!.toLowerCase()}";
                  } else {
                    return null;
                  }
                }
              : validator!,
          decoration: InputDecoration(
            //labelText: text,
            hintText: "$text",
            contentPadding: contentPadding,
            // alignLabelWithHint: true,
            filled: true,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            fillColor: textboxfillcolor ?? AppColor.grayBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s6),
              borderSide: BorderSide(
                color: AppColor.grayBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s6),
              borderSide: BorderSide(
                color: AppColor.grayBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s6),
              borderSide: BorderSide(
                color: AppColor.grayBorder,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s6),
              borderSide: BorderSide(
                color: AppColor.red,
              ),
            ),
            //hintText: 'Mobile No'
          ),
        ),
      ],
    );
  }
}

class CustomDropdownFormField<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? hint;
  final Widget? suffixIcon, prefixIcon;
  final Color? textboxfillcolor;
  final EdgeInsets? contentPadding;
  final String? Function(T?)? validator;
  final String Function(T?)? displayTextBuilder;

  const CustomDropdownFormField({
    Key? key,
    this.onChanged,
    this.value,
    required this.items,
    required this.hint,
    this.suffixIcon,
    this.prefixIcon,
    this.textboxfillcolor,
    this.contentPadding,
    this.validator,
    this.displayTextBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      menuMaxHeight: 400,
      validator: validator == null
          ? (val) {
        if (val == null || val.toString().trim().isEmpty) {
          return "Please ${hint!.toLowerCase()}";
        } else {
          return null;
        }
      }
          : validator!,
      decoration: InputDecoration(
        hintText: "$hint",
        contentPadding: contentPadding,
        filled: true,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: textboxfillcolor ?? AppColor.grayBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s6),
          borderSide: BorderSide(
            color: AppColor.grayBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s6),
          borderSide: BorderSide(
            color: AppColor.grayBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s6),
          borderSide: BorderSide(
            color: AppColor.grayBorder,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s6),
          borderSide: BorderSide(
            color: AppColor.red,
          ),
        ),
      ),
    );
  }
}


