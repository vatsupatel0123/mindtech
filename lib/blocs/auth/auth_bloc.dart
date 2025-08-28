import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/network/app_http_service.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/network/app_routing.dart';
import 'package:mindtech/app/network/app_url.dart';
import 'package:mindtech/app/utils/shared_preference_utility.dart';
import 'package:mindtech/blocs/auth/auth_event.dart';
import 'package:mindtech/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppHttp _appHttp = AppHttp();

  AuthBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      String? notificationToken = await FirebaseMessaging.instance.getToken();
      emit(AuthLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.LOGIN,
            body: {
              "email_id": event.emailId,
              "password": event.password,
              "notification_token": notificationToken ?? ''
            },
            is_auth: true
        );
        print(response);
        if (response['success']) {
          if(response['status'] == AppString.statusLogin){
            try {
              await SharedPreferencesUtility.setString('token', response['access_token']);
              await SharedPreferencesUtility.setBool("isLogin", true);
              await SharedPreferencesUtility.setString("userType", response['type']);
              await SharedPreferencesUtility.setString("userData", json.encode(response['data']));
              emit(AuthSuccess(message: response['message'],status: response['status'],type: response['type']));
            } catch (prefsError) {
              emit(AuthFailure(message: "Login successful, but data storage failed!"));
            }
          }else if(response['status'] == AppString.statusOtpSent){
            emit(AuthSuccess(message: response['message'],status: response['status'],userId: response['user_id']));
          }else{
            emit(AuthFailure(message: response['message'] ?? "Login failed"));
          }
        } else {
          emit(AuthFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(AuthFailure(message: "Login failed. Try again!"));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(VerifyOtpLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.VERIFY_OTP,
            body: {
              "user_id": event.userId,
              "otp": event.otp
            },
            is_auth: true
        );
        if (response['success'] && response['access_token'] != null) {
          if(event.isForgotScreen){
            emit(VerifyOtpSuccess(message: response['message'],status: AppString.statusUpdatePassword,userId: response['user_id']));
          }else{
            try {
              await SharedPreferencesUtility.setString('token', response['access_token']);
              await SharedPreferencesUtility.setBool("isLogin", true);
              await SharedPreferencesUtility.setString("userData", json.encode(response['data']));
              emit(VerifyOtpSuccess(message: response['message'],status: AppString.statusLogin,));
            } catch (prefsError) {
              emit(VerifyOtpFailure(message: "Login successful, but data storage failed!"));
            }
          }

        } else {
          emit(VerifyOtpFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(VerifyOtpFailure(message: "Login failed. Try again!"));
      }
    });

    on<ResendOtpEvent>((event, emit) async {
      emit(ResendOtpLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.RESEND_OTP,
            body: {
              "user_id": event.userId
            },
            is_auth: true
        );
        if (response['success']) {
          emit(ResendOtpSuccess(message: response['message']));
        } else {
          emit(ResendOtpFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(ResendOtpFailure(message: "Login failed. Try again!"));
      }
    });

    on<RegisterEvent>((RegisterEvent event, emit) async {
      emit(RegisterLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.REGISTER,
            body: event.user.toJson(),
            is_auth: true
        );
        if (response['success']) {
          if(response['status'] == AppString.statusLogin){
            try {
              await SharedPreferencesUtility.setString('token', response['access_token']);
              await SharedPreferencesUtility.setBool("isLogin", true);
              await SharedPreferencesUtility.setString("userData", json.encode(response['data']));
              emit(RegisterSuccess(message: response['message'],status: response['status']));
            } catch (prefsError) {
              emit(RegisterFailure(message: "Login successful, but data storage failed!"));
            }
          }else if(response['status'] == AppString.statusOtpSent){
            emit(RegisterSuccess(message: response['message'],status: response['status'],userId: response['user_id']));
          }else{
            emit(RegisterFailure(message: response['message'] ?? "Login failed"));
          }
        } else {
          emit(RegisterFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(RegisterFailure(message: "Login failed. Try again!"));
      }
    });

    on<GoogleLoginEvent>((GoogleLoginEvent event, emit) async {
      emit(GoogleLoginLoading());

      try {
        UserCredential user = await signInWithGoogle();
        final response = await _appHttp.post(
            url: AppUrl.CHECK_GOOGLEUSER,
            body: {
              "email_id": user.user!.email,
            },
            is_auth: true
        );
        print(response);
        if (response['success']) {
          if(response['status'] == AppString.statusLogin){
            try {
              await SharedPreferencesUtility.setString('token', response['access_token']);
              await SharedPreferencesUtility.setBool("isLogin", true);
              await SharedPreferencesUtility.setString("userData", json.encode(response['data']));
              emit(GoogleLoginSuccess(message: response['message'],status: response['status']));
            } catch (prefsError) {
              emit(GoogleLoginFailure(message: "Login successful, but data storage failed!"));
            }
          }
          else if(response['status'] == AppString.statusIncomplete){
            emit(GoogleLoginSuccess(message: response['message'],status: response['status'],user: user));
          }else{
            emit(GoogleLoginFailure(message: response['message'] ?? "Login failed"));
          }
        } else {
          emit(GoogleLoginFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(GoogleLoginFailure(message: "Login failed. Try again!"));
      }
    });

    on<GoogleRegisterEvent>((GoogleRegisterEvent event, emit) async {
      emit(GoogleRegisterLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.GOOGLE_REGISTER,
            body: event.user.toJson(),
            is_auth: true
        );
        if (response['success']) {
          try {
            await SharedPreferencesUtility.setString('token', response['access_token']);
            await SharedPreferencesUtility.setBool("isLogin", true);
            await SharedPreferencesUtility.setString("userData", json.encode(response['data']));
            emit(GoogleRegisterSuccess(message: response['message']));
          } catch (prefsError) {
            emit(GoogleLoginFailure(message: "Login successful, but data storage failed!"));
          }
        } else {
          emit(GoogleRegisterFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(GoogleRegisterFailure(message: "Login failed. Try again!"));
      }
    });

    on<ForgotEmailEvent>((ForgotEmailEvent event, emit) async {
      emit(ForgotEmailLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.CHECK_USER,
            body: {
              "email_id":event.emailId
            },
            is_auth: true
        );
        if (response['success']) {
          try {
            emit(ForgotEmailSuccess(message: response['message'],userId: response['user_id'],));
          } catch (prefsError) {
            emit(ForgotEmailFailure(message: "Login successful, but data storage failed!"));
          }
        } else {
          emit(ForgotEmailFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(ForgotEmailFailure(message: "Login failed. Try again!"));
      }
    });

    on<UpdatePasswordEvent>((UpdatePasswordEvent event, emit) async {
      emit(UpdatePasswordLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.UPDATE_PASSWORD,
            body: {
              "user_id": event.userId,
              "new_password": event.newPassword,
              "confirm_password": event.confirmPassword,
            },
            is_auth: true
        );
        print(response);
        if (response['success']) {
          emit(UpdatePasswordSuccess(message: response['message']));
        } else {
          emit(UpdatePasswordFailure(message: response['message'] ?? "Update Password failed"));
        }
      } catch (e) {
        emit(UpdatePasswordFailure(message: "Update Password failed. Try again!"));
      }
    });

    on<ChangePasswordEvent>((ChangePasswordEvent event, emit) async {
      emit(ChangePasswordLoading());

      try {
        final response = await _appHttp.post(
            url: AppUrl.CHANGE_PASSWORD,
            body: {
              "current_password": event.oldPassword,
              "new_password": event.newPassword,
              "confirm_password": event.confirmPassword,
            },
        );
        print(response);
        if (response['success']) {
          emit(ChangePasswordSuccess(message: response['message']));
        } else {
          emit(ChangePasswordFailure(message: response['message'] ?? "Change Password failed"));
        }
      } catch (e) {
        print(e);
        emit(ChangePasswordFailure(message: "Change Password failed. Try again!"));
      }
    });

    on<UpdateProfileEvent>((UpdateProfileEvent event, emit) async {
      emit(UpdateProfileLoading());

      try {
        final response = await _appHttp.postImage(
            url: AppUrl.UPDATE_PROFILE,
            body: event.user.toJson() .map((key, value) => MapEntry(key, value?.toString() ?? '')),
            file: {
              "photo":event.photo
            }
        );
        print(response);
        if (response['success']) {
          await SharedPreferencesUtility.setString("userData", json.encode(response['data']));
          emit(UpdateProfileSuccess(message: response['message']));
        } else {
          emit(UpdateProfileFailure(message: response['message'] ?? "Login failed"));
        }
      } catch (e) {
        emit(UpdateProfileFailure(message: "Login failed. Try again!"));
      }
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize(serverClientId: AppString.serverClientId);
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

}
