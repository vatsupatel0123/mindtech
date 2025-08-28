import 'package:equatable/equatable.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/mood_model.dart';
import 'package:mindtech/models/moodicon_model.dart';
import 'package:mindtech/models/notification_model.dart';
import 'package:mindtech/models/profilequestion_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final bool profileIsComplete;
  final List<ExpertModel> experts;
  final List<MoodIconModel> moods;
  final bool moodSubmittedToday;
  final MoodModel? todayMood;

  HomeLoaded({
    required this.profileIsComplete,
    required this.experts,
    required this.moods,
    required this.moodSubmittedToday,
    this.todayMood,
  });

  @override
  List<Object?> get props =>
      [profileIsComplete, experts, moods, moodSubmittedToday, todayMood];
}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class SaveMoodLoading extends HomeState {}

class SaveMoodSuccess extends HomeState {
  final String message;
  SaveMoodSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class SaveMoodFailure extends HomeState {
  final String message;
  SaveMoodFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class MoodLoading extends HomeState {}

class MoodLoaded extends HomeState {
  final List<MoodModel> moods;

  MoodLoaded({
    required this.moods,
  });

  @override
  List<Object?> get props => [moods];
}

class MoodFailure extends HomeState {
  final String message;

  MoodFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class SupportDetailsLoading extends HomeState {}

class SupportDetailsLoaded extends HomeState {
  final String contact_no;
  final String contact_email;

  SupportDetailsLoaded({
    required this.contact_no,
    required this.contact_email,
  });

  @override
  List<Object?> get props => [contact_no,contact_email];
}

class SupportDetailsFailure extends HomeState {
  final String message;

  SupportDetailsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetProfileQuestionLoading extends HomeState {}

class GetProfileQuestionLoaded extends HomeState {
  final ProfileQuestionModel question;

  GetProfileQuestionLoaded({
    required this.question,
  });

  @override
  List<Object?> get props => [question];
}

class GetProfileQuestionFailure extends HomeState {
  final String message;

  GetProfileQuestionFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class SavedProfileQuestionSuccess extends HomeState {
  final String message;

  SavedProfileQuestionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class NotificationLoading extends HomeState {}

class NotificationLoaded extends HomeState {
  final List<NotificationModel> notifications;

  NotificationLoaded({
    required this.notifications,
  });

  @override
  List<Object?> get props => [notifications];
}

class NotificationFailure extends HomeState {
  final String message;

  NotificationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

