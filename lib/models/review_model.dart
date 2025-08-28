class ReviewModel {
  int? appointmentId;
  int? expertId;
  int? reviewId;
  int? userId;
  String? rating;
  String? review;
  String? adeddDate;

  ReviewModel(
      {this.appointmentId,
        this.expertId,
        this.reviewId,
        this.userId,
        this.rating,
        this.review,
        this.adeddDate});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    appointmentId = (json['appointment_id'] != null)
        ? int.tryParse(json['appointment_id'].toString()) ?? 0
        : 0;

    expertId = (json['expert_id'] != null)
        ? int.tryParse(json['expert_id'].toString()) ?? 0
        : 0;

    reviewId = (json['review_id'] != null)
        ? int.tryParse(json['review_id'].toString()) ?? 0
        : 0;

    userId = (json['user_id'] != null)
        ? int.tryParse(json['user_id'].toString()) ?? 0
        : 0;
    rating = json['rating'];
    review = json['review'];
    adeddDate = json['adedd_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['expert_id'] = this.expertId;
    data['review_id'] = this.reviewId;
    data['user_id'] = this.userId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['adedd_date'] = this.adeddDate;
    return data;
  }
}
