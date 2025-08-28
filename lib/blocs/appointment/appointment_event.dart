import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAppointmentData extends AppointmentEvent {}

class SavedAppointmentEvent extends AppointmentEvent {
  final int expertId;
  final int packageId;
  final int slotId;
  final String contactNo;
  final String contactEmail;

  SavedAppointmentEvent({required this.expertId,required this.packageId,required this.slotId,required this.contactNo,required this.contactEmail});

  @override
  List<Object?> get props => [expertId, packageId, slotId, contactNo, contactEmail];

}

class GetExpertAppointmentSlots extends AppointmentEvent {
  final int expertId;
  GetExpertAppointmentSlots({required this.expertId});
}

class GetExpertAppointmentSlotsByDate extends AppointmentEvent {
  final int expertId;
  final DateTime date;
  GetExpertAppointmentSlotsByDate({required this.expertId,required this.date});
}

class ChangeAppointmentStatus extends AppointmentEvent {
  final int appointmentId;
  final int status;
  final String cancelledReason;
  ChangeAppointmentStatus({required this.appointmentId,required this.status,required this.cancelledReason});
}