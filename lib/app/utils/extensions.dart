import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TextFromFieldValidator on String {
  String? validateEmail() {
    if (isEmpty) {
      return 'Please enter email address';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(this)) {
      return 'Please enter a valid email ID';
    }
    return null;
  }

  String? validateEmpty(String fieldName) {
    if (isEmpty) {
      return 'Please ${fieldName.toString().toLowerCase()}';
    }
    return null;
  }

  String? validatePassword() {
    if (isEmpty) {
      return 'Please enter Password';
    } else if (length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validatePhoneNumber() {
    if (isEmpty) {
      return 'Please enter phone number';
    } else if (!RegExp(r'^\d{10}$').hasMatch(this)) {
      return 'Please enter 10 digit phone number';
    }
    return null;
  }

  String? validateNullPhoneNumber() {
    if (isEmpty) {
      return null;
    } else if (!RegExp(r'^\d{10}$').hasMatch(this)) {
      return 'Please enter 10 digit phone number';
    }
    return null;
  }
}

extension FormattedDateTime on DateTime {
  String toCustomString() {
    return DateFormat('yyyy-MM-dd hh:mm:ss a').format(this);
  }
}

extension CustomTimeFormatting on DateTime {
  String formatTime() {
    return "$hour:$minute";
  }
}

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year.toString()}";
  }
  String toFormattedYMDString() {
    return "${this.year.toString().padLeft(4, '0')}/${this.month.toString().padLeft(2, '0')}/${this.day.toString().padLeft(2, '0')}";
  }
}

extension UtcDateTimeFormatter on String {
  /// and formats as "dd-MM-yyyy h:mm a"
  String toLocalDateTime() {
    try {
      DateTime utcTime = DateTime.parse(this).toUtc();
      DateTime localTime = utcTime.toLocal();

      return "${DateFormat('dd-MM-yyyy').format(localTime)} ${DateFormat('h:mm a').format(localTime)}";
    } catch (e) {
      return '';
    }
  }

  /// Returns only the local date in dd-MM-yyyy format
  String toLocalDate() {
    try {
      DateTime utcTime = DateTime.parse(this).toUtc();
      DateTime localTime = utcTime.toLocal();
      return DateFormat('dd MMM yyyy').format(localTime).toUpperCase();
    } catch (e) {
      return '';
    }
  }

  /// Returns only the local time in h:mm a format
  String toLocalTime() {
    try {
      DateTime utcTime = DateTime.parse(this).toUtc();
      DateTime localTime = utcTime.toLocal();
      return DateFormat('h:mm a').format(localTime);
    } catch (e) {
      return '';
    }
  }

  /// Returns day text like "15th Jun" from UTC string
  String toDayText() {
    try {
      DateTime utcTime = DateTime.parse(this).toUtc();
      DateTime localTime = utcTime.toLocal();
      final suffix = _getDaySuffix(localTime.day);
      return "${localTime.day}$suffix ${DateFormat('MMM').format(localTime)}";
    } catch (e) {
      return '';
    }
  }

  /// Returns label like "Today", "Tomorrow", or weekday name
  String toDayLabel() {
    try {
      DateTime utcTime = DateTime.parse(this).toUtc();
      DateTime localTime = utcTime.toLocal();
      final now = DateTime.now();
      final diffDays = localTime.difference(DateTime(now.year, now.month, now.day)).inDays;
      if (diffDays == 0) return "Today";
      if (diffDays == 1) return "Tomorrow";
      return DateFormat('EEEE').format(localTime);
    } catch (e) {
      return '';
    }
  }

  /// Private helper to get ordinal suffix
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return "th";
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }
}

extension DateConversion on String {
  String? formatToDDMMYYYY() {
    // Check if the string is empty or null
    if (isEmpty) {
      return null; // Return null for empty or null strings
    }

    // Parse the string into a DateTime object
    DateTime? inputDate;
    try {
      inputDate = DateFormat('dd-MM-yyyy').parse(this);
    } catch (e) {
      print('Error parsing date: $e');
      return null; // Return null if there's an error parsing the date
    }

    // Format the DateTime object to the desired format
    return DateFormat('dd/MM/yyyy').format(inputDate!);
  }

  String? formatDashToDDMMYYYY() {
    // Check if the string is empty or null
    if (isEmpty) {
      return null; // Return null for empty or null strings
    }

    // Parse the string into a DateTime object
    DateTime? inputDate;
    try {
      inputDate = DateTime.parse(this);
    } catch (e) {
      print('Error parsing date: $e');
      return null; // Return null if there's an error parsing the date
    }

    // Format the DateTime object to the desired format
    return '${inputDate!.day.toString().padLeft(2, '0')}/${inputDate.month.toString().padLeft(2, '0')}/${inputDate.year}';
  }

  String formatToYYYYMMDD() {
    DateTime inputDate = DateFormat('dd/MM/yyyy').parseStrict(this);

    return DateFormat('yyyy-MM-dd').format(inputDate);
  }

  String fromatToDateTime(){
    String dateString = this;
    dateString = dateString.replaceAll('-', '/');
    List<String> dateTimeParts = dateString.split(' ');
    String timeString = dateTimeParts[1];
    List<String> timeParts = timeString.split(':');
    int hour = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    String amPmIndicator = dateTimeParts[2];
    if (amPmIndicator.toLowerCase() == 'pm' && hour != 12) {
      hour -= 12;
    }
    String formattedDate = '${dateTimeParts[0].split('/').reversed.join('/')} ${hour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $amPmIndicator';
    return formattedDate;
  }

}

extension StringDateTimeExtension on String {
  DateTime toDate() {
    try {
      List<String> parts = this.split('-');
      if (parts.length == 3) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);
        return DateTime(year, month, day);
      } else {
        throw FormatException("Invalid date format1. Expected: YYYY-MM-DD");
      }
    } catch (e) {
      throw FormatException("Invalid date format. Expected: YYYY-MM-DD");
    }
  }
}

extension StringTimeConversion on String {
  String toAmPmTime() {
    DateTime parsedTime = DateFormat('HH:mm:ss').parse('$this:00');
    return DateFormat('h:mm a').format(parsedTime);
  }

  DateTime getDateTimeFormat(){
    try {
      List<String> parts = this.split(' ');
      List<String> dateParts = parts[0].split('-');
      List<String> timeParts = parts[1].split(':');
      int year = int.parse(dateParts[2]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[0]);
      int hour = int.parse(timeParts[0]) + (parts[2] == 'pm' ? 12 : 0);
      int minute = int.parse(timeParts[1]);
      int second = int.parse(timeParts[2]);
      return DateTime(year, month, day, hour, minute, second);
    } catch (e) {
      print("Invalid date format");
      return DateTime.now(); // or any other default value
    }
  }

  String convertTo24HourFormat() {
    DateTime parsedTime = DateFormat('h:mm a').parse(this);
    String formattedTime = DateFormat('HH:mm').format(parsedTime);
    return formattedTime;
  }
  String timeAgo() {
    DateTime dateTime = this.getDateTimeFormat();
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return "$years ${years == 1 ? 'year' : 'years'} ago";
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return "$months ${months == 1 ? 'month' : 'months'} ago";
    } else if (difference.inDays > 7) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks ${weeks == 1 ? 'week' : 'weeks'} ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
    } else {
      return "just now";
    }
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

// extension RemoveHtmlTags on String? {
//   String? removeHtmlTagsAndEntities() {
//     // Check if the string is null or empty
//     if (this == null || this!.isEmpty) {
//       return this; // Return the original string if it's null or empty
//     }
//
//     // Decode HTML entities
//     final unescape = HtmlUnescape();
//     String decodedString = unescape.convert(this!);
//
//     // Use a regex to remove HTML tags from the decoded string
//     return decodedString.replaceAll(RegExp(r'<[^>]*>'), '');
//   }
// }
//
// extension HtmlToFlutterString on String {
//   Widget? toFlutterWidget() {
//     // Check if the string is null or empty
//     if (this == null || this.isEmpty) {
//       return Html(data: ""); // Return null for empty or null strings
//     }
//
//     final unescape = HtmlUnescape();
//     String decodedHtml = unescape.convert(this);
//     return Html(data: decodedHtml);
//   }
// }

extension ValueTypeExtension on int {
  // Define a method to get the text based on type
  String getExpenseType() {
    switch (this) {
      case 1:
        return 'Toll Tax';
      case 2:
        return 'Lunch & Dinner';
      case 3:
        return 'Travel';
      case 4:
        return 'Others';
      default:
        throw Exception('Invalid type');
    }
  }

  String getSubExpenseType() {
    switch (this) {
      case 1:
        return 'Train';
      case 2:
        return 'Flight';
      case 3:
        return 'Bus';
      case 4:
        return 'Car';
      case 5:
        return 'Bike';
      default:
        throw Exception('Invalid type');
    }
  }

  String getTimeAgo(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return "$years ${years == 1 ? 'year' : 'years'} ago";
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return "$months ${months == 1 ? 'month' : 'months'} ago";
    } else if (difference.inDays > 7) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks ${weeks == 1 ? 'week' : 'weeks'} ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
    } else {
      return "just now";
    }
  }
}
