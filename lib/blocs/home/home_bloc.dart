import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindtech/app/network/app_http_service.dart';
import 'package:mindtech/app/network/app_url.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/mood_model.dart';
import 'package:mindtech/models/moodicon_model.dart';
import 'package:mindtech/models/notification_model.dart';
import 'package:mindtech/models/profilequestion_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppHttp _appHttp = AppHttp();

  HomeBloc() : super(HomeInitial()) {

    on<GetHomeData>((event, emit) async {
      emit(HomeLoading());

      try {
        final response = await _appHttp.get(
            url: AppUrl.GET_HOMEDATA,
        );
        if (response['success']) {
          List<ExpertModel> experts = (response["experts"] as List)
              .map<ExpertModel>((json) => ExpertModel.fromJson(json))
              .toList();
          List<MoodIconModel> moods = (response["moods"] as List)
              .map<MoodIconModel>((json) => MoodIconModel.fromJson(json))
              .toList();

          MoodModel? todayMood;
          if (response["today_mood"] != null) {
            todayMood = MoodModel.fromJson(response["today_mood"]);
          }
          emit(HomeLoaded(
            profileIsComplete: response["profile_is_complete"] ?? false,
            experts: experts,
            moods: moods,
            moodSubmittedToday: response["mood_submitted_today"] ?? false,
            todayMood: todayMood,
          ));
        }
        else {
          emit(HomeFailure(message: response['message'] ?? ""));
        }
      } catch (e) {
        print(e);
        emit(HomeFailure(message: "Get Home data Failed. Try again!"));
      }
    });

    on<SaveMoodEvent>((SaveMoodEvent event, emit) async {
      emit(GetProfileQuestionLoading());
      try {
        final response = await _appHttp.post(
            url: AppUrl.SAVE_MOOD,
            body: {
              "mood_id":event.moodId,
              "mood_note":event.moodNote,
            },
        );
        if (response['success']) {
          try {
            add(GetHomeData());
            emit(SaveMoodSuccess(message: response['message']));
          } catch (prefsError) {
            emit(GetProfileQuestionFailure(message: "Login successful, but data storage failed!"));
          }
        } else {
          emit(SaveMoodFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(SaveMoodFailure(message: "Login failed. Try again!"));
      }
    });

    on<GetMoodData>((event, emit) async {
      emit(MoodLoading());

      try {
        final response = await _appHttp.get(
          url: AppUrl.GET_MOODS,
        );
        print(response);
        if (response['success']) {
          List<MoodModel> moods = (response["data"] as List)
              .map<MoodModel>((json) => MoodModel.fromJson(json))
              .toList();

          emit(MoodLoaded(moods: moods));
        } else {
          emit(MoodFailure(
              message: response['message'] ?? "Failed to fetch moods"));
        }
      } catch (e) {
        print(e);
        emit(MoodFailure(message: "No Data Found!"));
      }
    });

    on<GetSupportDetails>((event, emit) async {
      emit(SupportDetailsLoading());

      try {
        final response = await _appHttp.get(
          url: AppUrl.GET_SUPPORT_DETAILS,
        );
        if (response['success']) {
          emit(SupportDetailsLoaded(contact_no: response['contact_no'],contact_email: response['contact_email']));
        } else {
          emit(SupportDetailsFailure(
              message: response['message'] ?? "Failed to fetch moods"));
        }
      } catch (e) {
        print(e);
        emit(SupportDetailsFailure(message: "No Data Found!"));
      }
    });

    on<GetProfileQuestion>((event, emit) async {
      emit(GetProfileQuestionLoading());

      try {
        final response = await _appHttp.get(
          url: AppUrl.GET_PROFILE_QUESTION+"/"+(event.step ?? '').toString(),
        );
        print(response);
        if (response['success']) {
          ProfileQuestionModel profilequestion = ProfileQuestionModel.fromJson(response);

          emit(GetProfileQuestionLoaded(question: profilequestion));
        } else {
          emit(GetProfileQuestionFailure(
              message: response['message'] ?? "Failed to fetch moods"));
        }
      } catch (e) {
        print(e);
        emit(GetProfileQuestionFailure(message: "No Data Found!"));
      }
    });

    on<SaveProfileQuestionEvent>((event, emit) async {
      emit(GetProfileQuestionLoading());
      try {
        final response = await _appHttp.post(
          url: AppUrl.SAVED_PROFILE_QUESTION,
          body: {
            "que_id":event.queId,
            "option_id":event.optionId,
          },
        );
        if (response['success']) {
            if(response['all_answered']){
              emit(SavedProfileQuestionSuccess(message: response['message']));
            }else{
              ProfileQuestionModel profilequestion = ProfileQuestionModel.fromJson(response);
              emit(GetProfileQuestionLoaded(question: profilequestion));
            }
        } else {
          emit(GetProfileQuestionFailure(message: response['message'] ?? "Saved Failed"));
        }
      } catch (e) {
        emit(GetProfileQuestionFailure(message: "Saved failed. Try again!"));
      }
    });

    on<GetNotificationData>((event, emit) async {
      emit(NotificationLoading());

      try {
        final response = await _appHttp.get(
          url: AppUrl.GET_NOTIFICATIONS,
        );
        if (response['success']) {
          List<NotificationModel> notifications = (response["data"] as List)
              .map<NotificationModel>((json) => NotificationModel.fromJson(json))
              .toList();

          emit(NotificationLoaded(notifications: notifications));
        } else {
          emit(NotificationFailure(
              message: response['message'] ?? "Failed to fetch moods"));
        }
      } catch (e) {
        print(e);
        emit(NotificationFailure(message: "No Data Found!"));
      }
    });
  }
}
