import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindtech/app/utils/shared_preference_utility.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/user_model.dart';
import 'package:toastification/toastification.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/utils/extensions.dart';

class CommonHelper {
// Toast
  static flutterToast(context, message,
      {description,
      AlignmentGeometry? alignment,
      CloseButtonShowType? closeButtonShowType,
      ToastificationType? type,
      Widget? icon,
      ToastificationStyle? style,
      bool isSuccess = false}) {
    toastification.dismissAll();
    return toastification.show(
      context: context,
      // title: Text(
      //   isSuccess ? "Success" : "Error",
      //   style: AppTextStyle.h3.copyWith(fontSize: 12,height: 1),
      // ),
      dragToClose: true,
      description: Text(
        message ?? "",
        style: AppTextStyle.h3.copyWith(fontSize: 16),
      ),
      borderRadius: BorderRadius.circular(7),
      showIcon: false,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: alignment ?? Alignment.bottomCenter,
      showProgressBar: false,
      closeButtonShowType: closeButtonShowType ?? CloseButtonShowType.none,
      type: type ??
          (isSuccess ? ToastificationType.success : ToastificationType.error),
      icon: icon ??
          (isSuccess
              ? Icon(
                  Icons.done,
                  color: AppColor.green,
                )
              : Icon(
                  Icons.error_outline_rounded,
                  color: AppColor.red,
                )),
      style: style ?? ToastificationStyle.flatColored,
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: const EdgeInsets.fromLTRB(15, 5, 0, 5)
    );
  }

// Toast

//Date Picker
  static Future<DateTime> chooseDate(BuildContext context,
      TextEditingController dob, DateTime selectedDateTime,
      {DateTime? firstDate}) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: firstDate ?? DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      print("Selected date = $pickedDate");
      selectedDateTime = pickedDate;
      dob.text = pickedDate.toFormattedString();
      return selectedDateTime;
    }
    return selectedDateTime;
  }

//Date Picker

//Time Picker
  static Future<TimeOfDay> chooseTime(
      BuildContext context, TextEditingController timeController) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      print("Selected time = $pickedTime");
      timeController.text = pickedTime.format(context); // Format the time
      return pickedTime;
    }
    return initialTime;
  }

  static Future<UserModel?> getUserData() async {
    final jsonString = await SharedPreferencesUtility.getString("userData");
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final Map<String, dynamic> userMap = json.decode(jsonString);
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }
  static Future<ExpertModel?> getExpertData() async {
    final jsonString = await SharedPreferencesUtility.getString("userData");
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final Map<String, dynamic> userMap = json.decode(jsonString);
      return ExpertModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }
  static Future<String?> getUserId() async {
    final jsonString = await SharedPreferencesUtility.getString("userData");
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final Map<String, dynamic> userMap = json.decode(jsonString);
      return UserModel.fromJson(userMap).userId.toString();
    } catch (e) {
      return null;
    }
  }

  static String formatNotificationTime(String utcString) {
    // Parse the UTC datetime string
    DateTime utcDateTime = DateTime.parse(utcString).toUtc();

    // Convert to device local time
    DateTime localDateTime = utcDateTime.toLocal();
    DateTime now = DateTime.now();

    Duration diff = now.difference(localDateTime);

    if (diff.inMinutes < 2) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 3) {
      return '${diff.inDays} days ago';
    } else {
      return DateFormat('dd MMM yyyy - hh:mm a').format(localDateTime);
    }
  }

}

class Validators {
  static String? validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Enter $fieldName";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter mobile number";
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Enter a valid 10-digit mobile number";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter email";
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }
}
