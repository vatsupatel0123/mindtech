class NotificationModel {
  int? notificationId;
  String? notificationTitle;
  String? notificationDesc;
  String? notificationUrl;
  String? notificationDate;

  NotificationModel(
      {this.notificationId,
        this.notificationTitle,
        this.notificationDesc,
        this.notificationUrl,
        this.notificationDate});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    notificationTitle = json['notification_title'];
    notificationDesc = json['notification_desc'];
    notificationUrl = json['notification_url'];
    notificationDate = json['notification_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['notification_title'] = this.notificationTitle;
    data['notification_desc'] = this.notificationDesc;
    data['notification_url'] = this.notificationUrl;
    data['notification_date'] = this.notificationDate;
    return data;
  }
}
