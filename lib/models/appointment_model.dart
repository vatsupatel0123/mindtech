import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/review_model.dart';
import 'package:mindtech/models/user_model.dart';

class AppointmentModel {
  int? appointmentId;
  int? userId;
  int? packageId;
  int? slotId;
  String? appointmentDate;
  String? appointmentTime;
  int? expertId;
  String? contactNo;
  int? status;
  String? cancelledReason;
  String? appointmentUrl;
  bool? isUpcoming;
  ExpertModel? expert;
  UserModel? user;
  ReviewModel? review;

  AppointmentModel(
      {this.appointmentId,
        this.userId,
        this.packageId,
        this.slotId,
        this.appointmentDate,
        this.appointmentTime,
        this.expertId,
        this.contactNo,
        this.cancelledReason,
        this.status,
        this.appointmentUrl,
        this.isUpcoming,
        this.expert,
        this.user,
        this.review});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    userId = json['user_id'];
    packageId = json['package_id'];
    slotId = json['slot_id'];
    final String? appointmentDateStr = json['appointment_date'];
    final String? appointmentTimeStr = json['appointment_time'];
    appointmentDate = appointmentDateStr;
    appointmentTime = appointmentTimeStr;
    expertId = json['expert_id'];
    contactNo = json['contact_no'];
    cancelledReason = json['cancelled_reason'];
    status = json['status'];
    appointmentUrl = json['appointment_url'];
    if (appointmentDateStr != null && appointmentTimeStr != null) {
      try {
        // Parse full DateTime from both strings
        DateTime datePart = DateTime.parse(appointmentDateStr).toUtc();
        DateTime timePart = DateTime.parse(appointmentTimeStr).toUtc();

        // Extract date components from datePart
        final year = datePart.year;
        final month = datePart.month;
        final day = datePart.day;

        // Extract time components from timePart
        final hour = timePart.hour;
        final minute = timePart.minute;
        final second = timePart.second;

        // Combine date and time into one UTC DateTime
        final utcDateTime = DateTime.utc(year, month, day, hour, minute, second);

        final localDateTime = utcDateTime.toLocal();
        final now = DateTime.now();

        isUpcoming = localDateTime.isAfter(now);
      } catch (e) {
        isUpcoming = false; // fallback on error
      }
    } else {
      isUpcoming = false;
    }
    review = json['review'] != null ? new ReviewModel.fromJson(json['review']) : null;
    expert = json['expert'] != null ? new ExpertModel.fromJson(json['expert']) : null;
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['user_id'] = this.userId;
    data['package_id'] = this.packageId;
    data['slot_id'] = this.slotId;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['expert_id'] = this.expertId;
    data['contact_no'] = this.contactNo;
    data['cancelled_reason'] = this.cancelledReason;
    data['status'] = this.status;
    data['isUpcoming'] = this.isUpcoming;
    if (this.review != null) {
      data['review'] = this.review!.toJson();
    }
    if (this.expert != null) {
      data['expert'] = this.expert!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
