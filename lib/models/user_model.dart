class UserModel {
  int? userId;
  String? emailId;
  String? password;
  String? fullName;
  String? photo;
  String? gender;
  String? age;
  String? preferredLanguage;
  String? occupation;
  String? employmentStatus;
  String? otp;
  String? notificationToken;

  UserModel(
      {this.userId,
        this.emailId,
        this.password,
        this.fullName,
        this.photo,
        this.gender,
        this.age,
        this.preferredLanguage,
        this.occupation,
        this.employmentStatus,
        this.otp,
        this.notificationToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    emailId = json['email_id'];
    password = json['password'];
    fullName = json['full_name'];
    photo = json['photo'];
    gender = json['gender'];
    age = json['age'];
    preferredLanguage = json['preferred_language'];
    occupation = json['occupation'];
    employmentStatus = json['employment_status'];
    otp = json['otp'];
    notificationToken = json['notification_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['email_id'] = this.emailId;
    data['password'] = this.password;
    data['full_name'] = this.fullName;
    data['photo'] = this.photo;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['preferred_language'] = this.preferredLanguage;
    data['occupation'] = this.occupation;
    data['employment_status'] = this.employmentStatus;
    data['otp'] = this.otp;
    data['notification_token'] = this.notificationToken;
    return data;
  }
}