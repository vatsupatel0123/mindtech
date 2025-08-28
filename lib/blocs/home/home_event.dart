import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetHomeData extends HomeEvent {}

class SaveMoodEvent extends HomeEvent {
  final int moodId;
  final String moodNote;

  SaveMoodEvent({required this.moodId,required this.moodNote,});

  @override
  List<Object?> get props => [moodId,moodNote];
}

class GetMoodData extends HomeEvent {}

class GetNotificationData extends HomeEvent {}

class GetSupportDetails extends HomeEvent {}

class GetProfileQuestion extends HomeEvent {
  final int? step;

  GetProfileQuestion({this.step});

  @override
  List<Object?> get props => [step];
}

class SaveProfileQuestionEvent extends HomeEvent {
  final int queId;
  final int optionId;

  SaveProfileQuestionEvent({required this.queId,required this.optionId,});

  @override
  List<Object?> get props => [queId,optionId];
}

