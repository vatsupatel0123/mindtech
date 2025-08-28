import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mindtech/app/network/app_http_service.dart';
import 'package:mindtech/app/network/app_url.dart';
import 'package:mindtech/blocs/appointment/appointment_event.dart';
import 'package:mindtech/blocs/appointment/appointment_state.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/expert_slot_model.dart';
import 'package:mindtech/models/mood_model.dart';
import 'package:mindtech/models/package_model.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppHttp _appHttp = AppHttp();

  AppointmentBloc() : super(AppointmentInitial()) {
    on<GetAppointmentData>((event, emit) async {
      emit(AppointmentLoading());

      try {
        final response = await _appHttp.get(
          url: AppUrl.GET_APPOINTMENTS,
        );
        print(response);
        if (response['success']) {
          List<AppointmentModel> appointments = (response["data"] as List)
              .map<AppointmentModel>((json) => AppointmentModel.fromJson(json))
              .toList();

          emit(AppointmentLoaded(appointments: appointments));
        } else {
          emit(AppointmentFailure(
              message: response['message'] ?? "Failed to fetch appointments"));
        }
      } catch (e) {
        print(e);
        emit(AppointmentFailure(message: "No Data Found!"));
      }
    });

    on<SavedAppointmentEvent>((event, emit) async {
      emit(SaveAppointmentLoading());

      try {
        final response = await _appHttp.post(
          url: AppUrl.SAVED_APPOINTMENT,
          body: {
            "expert_id": event.expertId,
            "package_id": event.packageId,
            "slot_id": event.slotId,
            "contact_no": event.contactNo,
            "contact_email": event.contactEmail,
          }
        );
        print(response);
        if (response['success']) {
          emit(SaveAppointmentSuccess(message: response['message'] ?? "Failed to saved appointments"));
        } else {
          emit(SaveAppointmentFailure(message: response['message'] ?? "Failed to saved appointments"));
        }
      } catch (e) {
        print(e);
        emit(SaveAppointmentFailure(message: "Failed to saved appointments"));
      }
    });

    on<GetExpertAppointmentSlots>((event, emit) async {
      emit(AppointmentLoading());

      try {
        final response = await _appHttp.get(
          url: "${AppUrl.GET_EXPERTS_SLOTS}/${event.expertId}",
        );
        print(response);
        if (response['success']) {
          List<ExpertSlotModel> slots = (response["availability"] as List)
              .map<ExpertSlotModel>((json) => ExpertSlotModel.fromJson(json))
              .toList();
          List<PackageModel> packages = (response["packages"] as List)
              .map<PackageModel>((json) => PackageModel.fromJson(json))
              .toList();
          List<DateTime> availableDates = (response["available_dates"] as List)
              .map<DateTime>((date) => DateTime.parse(date).toLocal())
              .toList();
          emit(ExpertAppointmentSlotsLoaded(slots: slots,packages: packages,availableDates: availableDates));
        } else {
          emit(AppointmentFailure(message: response['message'] ?? "Failed to fetch expert details"));
        }
      } catch (e) {
        print(e);
        emit(AppointmentFailure(message: "No Data Found!"));
      }
    });

    on<GetExpertAppointmentSlotsByDate>((event, emit) async {
      try {
        final formattedDate = DateFormat('yyyy-MM-dd').format(event.date);
        final response = await _appHttp.get(
          url: "${AppUrl.GET_EXPERTS_SLOTS}/${event.expertId}/${formattedDate}",
        );
        if (response['success']) {
          List<SlotsModel> slots = (response["data"] as List)
              .map<SlotsModel>((json) => SlotsModel.fromJson(json))
              .toList();
          if (state is ExpertAppointmentSlotsLoaded) {
            emit((state as ExpertAppointmentSlotsLoaded).copyWith(dateSlots: slots));
          }
        } else {
          emit(AppointmentFailure(message: response['message'] ?? "Failed to fetch expert details"));
        }
      } catch (e) {
        print(e);
        emit(AppointmentFailure(message: "No Data Found!"));
      }
    });

    on<ChangeAppointmentStatus>((event, emit) async {
      emit(ChangeAppointmentStatusLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.CHANGE_APPOINTMENT_STATUS,
            body: {
              "appointment_id": event.appointmentId,
              "status": event.status,
              "cancelled_reason": event.cancelledReason
            }
        );
        print(response);
        if (response['success']) {
          emit(ChangeAppointmentStatusSuccess(message: response['message']));
        } else {
          emit(ChangeAppointmentStatusFailure(message: response['message']));
        }
      } catch (e) {
        emit(ChangeAppointmentStatusFailure(message: "Saved review failed!"));
      }
    });
  }
}
