import 'package:equatable/equatable.dart';

abstract class ExpertEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetExpertData extends ExpertEvent {}

class SearchExpertData extends ExpertEvent {
  final String query;
  SearchExpertData({required this.query});
}

class GetExpertDetails extends ExpertEvent {
  final int expertId;
  GetExpertDetails({required this.expertId});
}

class SavedExpertReview extends ExpertEvent {
  final int expertId;
  final int rating;
  final int appointmentId;
  final String review;
  SavedExpertReview({required this.expertId,required this.appointmentId,required this.rating,required this.review});
}

class GetExpertAppoinmentData extends ExpertEvent {
  final String limit;
  GetExpertAppoinmentData({required this.limit});
}