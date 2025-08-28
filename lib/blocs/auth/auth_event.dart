import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindtech/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String emailId;
  final String password;

  LoginEvent({required this.emailId, required this.password});

  @override
  List<Object?> get props => [emailId, password];
}

class VerifyOtpEvent extends AuthEvent {
  final int userId;
  final String otp;
  final bool isForgotScreen;

  VerifyOtpEvent({required this.userId, required this.otp, this.isForgotScreen=false});

  @override
  List<Object?> get props => [userId, otp, isForgotScreen];
}

class ResendOtpEvent extends AuthEvent {
  final int userId;

  ResendOtpEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RegisterEvent extends AuthEvent {
  final UserModel user;

  RegisterEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class GoogleLoginEvent extends AuthEvent {
  GoogleLoginEvent();
}

class GoogleRegisterEvent extends AuthEvent {
  final UserModel user;

  GoogleRegisterEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class ForgotEmailEvent extends AuthEvent {
  final String emailId;

  ForgotEmailEvent({required this.emailId});

  @override
  List<Object?> get props => [emailId];
}

class UpdatePasswordEvent extends AuthEvent {
  final String userId;
  final String newPassword;
  final String confirmPassword;

  UpdatePasswordEvent({required this.userId,required this.newPassword,required this.confirmPassword});

  @override
  List<Object?> get props => [userId,newPassword,confirmPassword];
}

class ChangePasswordEvent extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordEvent({required this.oldPassword,required this.newPassword,required this.confirmPassword});

  @override
  List<Object?> get props => [oldPassword,newPassword,confirmPassword];
}

class UpdateProfileEvent extends AuthEvent {
  final UserModel user;
  final File? photo;

  UpdateProfileEvent({required this.user,this.photo});

  @override
  List<Object?> get props => [user,photo];
}

