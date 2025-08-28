import 'package:equatable/equatable.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/models/expert_slot_model.dart';
import 'package:mindtech/models/mood_model.dart';
import 'package:mindtech/models/package_model.dart';

abstract class AppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<AppointmentModel> appointments;

  AppointmentLoaded({
    required this.appointments,
  });

  @override
  List<Object?> get props => [appointments];
}

class AppointmentFailure extends AppointmentState {
  final String message;

  AppointmentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class SaveAppointmentLoading extends AppointmentState {}

class SaveAppointmentSuccess extends AppointmentState {
  final String message;
  SaveAppointmentSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class SaveAppointmentFailure extends AppointmentState {
  final String message;
  SaveAppointmentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ExpertAppointmentSlotsLoaded extends AppointmentState with EquatableMixin {
  final List<ExpertSlotModel> slots;
  final List<PackageModel> packages;
  final List<DateTime> availableDates;
  final List<SlotsModel> dateSlots;

  ExpertAppointmentSlotsLoaded({
    required this.slots,
    required this.packages,
    required this.availableDates,
    this.dateSlots = const [],
  });

  ExpertAppointmentSlotsLoaded copyWith({
    List<ExpertSlotModel>? slots,
    List<PackageModel>? packages,
    List<DateTime>? availableDates,
    List<SlotsModel>? dateSlots,
  }) {
    return ExpertAppointmentSlotsLoaded(
      slots: slots ?? this.slots,
      packages: packages ?? this.packages,
      availableDates: availableDates ?? this.availableDates,
      dateSlots: dateSlots ?? this.dateSlots,
    );
  }

  @override
  List<Object?> get props => [slots, packages, availableDates, dateSlots];
}

class ChangeAppointmentStatusLoading extends AppointmentState {}

class ChangeAppointmentStatusSuccess extends AppointmentState {
  final String message;

  ChangeAppointmentStatusSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
class ChangeAppointmentStatusFailure extends AppointmentState {
  final String message;

  ChangeAppointmentStatusFailure({required this.message});

  @override
  List<Object?> get props => [message];
}


