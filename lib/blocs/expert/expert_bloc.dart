import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindtech/app/network/app_http_service.dart';
import 'package:mindtech/app/network/app_url.dart';
import 'package:mindtech/blocs/appointment/appointment_event.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/expert/expert_state.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/expert_slot_model.dart';
import 'package:mindtech/models/package_model.dart';

class ExpertBloc extends Bloc<ExpertEvent, ExpertState> {
  final AppHttp _appHttp = AppHttp();
  List<ExpertModel> _allExperts = [];

  ExpertBloc() : super(ExpertInitial()) {
    on<GetExpertData>(_onGetExpertData);
    on<SearchExpertData>(_onSearchExpertData);
    on<GetExpertDetails>(_onGetExpertDetails);
    on<SavedExpertReview>(_onSavedExpertReview);
    on<GetExpertAppoinmentData>(_onGetExpertAppoinmentData);
  }

  Future<void> _onGetExpertData(GetExpertData event, Emitter<ExpertState> emit) async {
    emit(ExpertLoading());

    try {
      final response = await _appHttp.get(url: AppUrl.GET_EXPERTS);

      if (response['success']) {
        _allExperts = (response["data"] as List)
            .map<ExpertModel>((json) => ExpertModel.fromJson(json))
            .toList();

        emit(ExpertLoaded(experts: _allExperts));
      } else {
        emit(ExpertFailure(message: response['message'] ?? "Failed to fetch experts"));
      }
    } catch (e) {
      print(e);
      emit(ExpertFailure(message: "No Data Found!"));
    }
  }

  Future<void> _onGetExpertDetails(GetExpertDetails event, Emitter<ExpertState> emit) async {
    emit(ExpertLoading());

    try {
      final response = await _appHttp.get(
        url: "${AppUrl.GET_EXPERTS}/${event.expertId}",
      );
      print(response);

      if (response['success']) {
        ExpertModel experts = ExpertModel.fromJson(response["data"]);
        emit(ExpertDetailsLoaded(expert: experts));
      } else {
        emit(ExpertFailure(message: response['message'] ?? "Failed to fetch expert details"));
      }
    } catch (e) {
      emit(ExpertFailure(message: "No Data Found!"));
    }
  }

  Future<void> _onSavedExpertReview(SavedExpertReview event, Emitter<ExpertState> emit) async {
    emit(SavedExpertReviewLoading());

    try {
      final response = await _appHttp.post(
        url: AppUrl.SAVED_EXPERT_REVIEW,
        body: {
          "expert_id": event.expertId,
          "rating": event.rating,
          "appointment_id": event.appointmentId,
          "review": event.review
        }
      );
      print(response);
      if (response['success']) {
        emit(SavedExpertReviewSuccess(message: response['message']));
      } else {
        emit(SavedExpertReviewFailure(message: response['message']));
      }
    } catch (e) {
      emit(SavedExpertReviewFailure(message: "Saved review failed!"));
    }
  }

  Future<void> _onGetExpertAppoinmentData(GetExpertAppoinmentData event, Emitter<ExpertState> emit) async {
    emit(GetExpertAppointmentLoading());

    try {
      String currentUtc = DateTime.now().toUtc().toIso8601String();
      final response = await _appHttp.post(
          url: AppUrl.GET_EXPERT_APPOINTMENTS,
          body: {
            "current_time": currentUtc,
            "limit": event.limit
          }
      );
      print(response);
      if (response['success']) {
        List<AppointmentModel> upcoming = (response["upcoming"] as List)
            .map<AppointmentModel>((json) => AppointmentModel.fromJson(json))
            .toList();

        List<AppointmentModel> completed = (response["completed"] as List)
            .map<AppointmentModel>((json) => AppointmentModel.fromJson(json))
            .toList();

        emit(GetExpertAppointmentLoaded(upcoming: upcoming,completed: completed));
      } else {
        emit(GetExpertAppointmentFailure(message: response['message']));
      }
    } catch (e) {
      emit(GetExpertAppointmentFailure(message: "Get Expert Appointment Failed"));
    }
  }

  Future<void> _onSearchExpertData(SearchExpertData event, Emitter<ExpertState> emit) async {
    if (_allExperts.isEmpty) return;

    final query = event.query.toLowerCase();
    final filteredExperts = _allExperts.where((expert) {
      return expert.expertName!.toLowerCase().contains(query) ||
          expert.qualification!.toLowerCase().contains(query);
    }).toList();

    emit(ExpertLoaded(experts: filteredExperts));
  }
}

