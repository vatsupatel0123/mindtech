import 'package:equatable/equatable.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/expert_slot_model.dart';
import 'package:mindtech/models/mood_model.dart';
import 'package:mindtech/models/package_model.dart';

abstract class ExpertState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpertInitial extends ExpertState {}

class ExpertLoading extends ExpertState {}

class ExpertLoaded extends ExpertState {
  final List<ExpertModel> experts;

  ExpertLoaded({
    required this.experts,
  });

  @override
  List<Object?> get props => [experts];
}

class ExpertDetailsLoaded extends ExpertState {
  final ExpertModel expert;

  ExpertDetailsLoaded({
    required this.expert,
  });

  @override
  List<Object?> get props => [expert];
}


class ExpertFailure extends ExpertState {
  final String message;

  ExpertFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class SavedExpertReviewLoading extends ExpertState {}

class SavedExpertReviewSuccess extends ExpertState {
  final String message;

  SavedExpertReviewSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class SavedExpertReviewFailure extends ExpertState {
  final String message;
  SavedExpertReviewFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetExpertAppointmentLoading extends ExpertState {}

class GetExpertAppointmentLoaded extends ExpertState {
  final List<AppointmentModel> upcoming;
  final List<AppointmentModel> completed;

  GetExpertAppointmentLoaded({
    required this.upcoming,
    required this.completed,
  });

  @override
  List<Object?> get props => [upcoming,completed];
}

class GetExpertAppointmentFailure extends ExpertState {
  final String message;

  GetExpertAppointmentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

