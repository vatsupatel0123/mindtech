import 'package:mindtech/models/review_model.dart';
import 'package:mindtech/models/skill_model.dart';

class ExpertModel {
  int? expertId;
  String? expertName;
  String? photo;
  String? qualification;
  String? experienceYears;
  String? languagesSpoken;
  String? availabeOn;
  String? bio;
  String? avgRating;
  String? totalReviews;
  List<ReviewModel>? review;
  List<SkillModel>? skill;

  ExpertModel({
    this.expertId,
    this.expertName,
    this.photo,
    this.qualification,
    this.experienceYears,
    this.languagesSpoken,
    this.availabeOn,
    this.bio,
    this.avgRating,
    this.totalReviews,
    this.review,
    this.skill,
  });

  ExpertModel.fromJson(Map<String, dynamic> json) {
    expertId = json['expert_id'];
    expertName = json['expert_name'];
    photo = json['photo'];
    qualification = json['qualification'];
    experienceYears = json['experience_years'];
    languagesSpoken = json['languages_spoken'];
    availabeOn = json['availabe_on'];
    bio = json['bio'];
    avgRating = json['avg_rating']?.toString();
    totalReviews = json['total_reviews']?.toString();

    if (json['skills'] != null) {
      List<SkillModel> skills = (json["skills"] as List)
          .map<SkillModel>((json) => SkillModel.fromJson(json))
          .toList();
      skill = skills;
    }

    if (json['reviews'] != null) {
      List<ReviewModel> reviews = (json["reviews"] as List)
          .map<ReviewModel>((json) => ReviewModel.fromJson(json))
          .toList();
      review = reviews;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['expert_id'] = expertId;
    data['expert_name'] = expertName;
    data['photo'] = photo;
    data['qualification'] = qualification;
    data['experience_years'] = experienceYears;
    data['languages_spoken'] = languagesSpoken;
    data['availabe_on'] = availabeOn;
    data['bio'] = bio;
    data['avg_rating'] = avgRating;
    data['total_reviews'] = totalReviews;

    if (review != null) {
      data['reviews'] = review!.map((v) => v.toJson()).toList();
    }

    if (skill != null) {
      data['skills'] = skill!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}