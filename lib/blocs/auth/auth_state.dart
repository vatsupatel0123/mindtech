import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final int? userId;
  final String? status;
  final String? type;
  AuthSuccess({required this.message,this.status,this.userId,this.type});

  @override
  List<Object?> get props => [message,status,userId,type];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {
  final String message;
  final int? userId;
  final String? status;
  VerifyOtpSuccess({required this.message,this.status,this.userId});

  @override
  List<Object?> get props => [message,status,userId];
}

class VerifyOtpFailure extends AuthState {
  final String message;
  VerifyOtpFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResendOtpLoading extends AuthState {}

class ResendOtpSuccess extends AuthState {
  final String message;
  ResendOtpSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResendOtpFailure extends AuthState {
  final String message;
  ResendOtpFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;
  final int? userId;
  final String? status;
  RegisterSuccess({required this.message,this.status,this.userId});

  @override
  List<Object?> get props => [message,status,userId];
}

class RegisterFailure extends AuthState {
  final String message;
  RegisterFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GoogleLoginLoading extends AuthState {}

class GoogleLoginSuccess extends AuthState {
  final String message;
  final UserCredential? user;
  final String? status;
  GoogleLoginSuccess({required this.message,this.status,this.user});

  @override
  List<Object?> get props => [message,status,user];
}

class GoogleLoginFailure extends AuthState {
  final String message;
  GoogleLoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GoogleRegisterLoading extends AuthState {}

class GoogleRegisterSuccess extends AuthState {
  final String message;
  GoogleRegisterSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class GoogleRegisterFailure extends AuthState {
  final String message;
  GoogleRegisterFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ForgotEmailLoading extends AuthState {}

class ForgotEmailSuccess extends AuthState {
  final String message;
  final int userId;
  ForgotEmailSuccess({required this.message, required this.userId});

  @override
  List<Object?> get props => [message,userId];
}

class ForgotEmailFailure extends AuthState {
  final String message;
  ForgotEmailFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdatePasswordLoading extends AuthState {}

class UpdatePasswordSuccess extends AuthState {
  final String message;
  UpdatePasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdatePasswordFailure extends AuthState {
  final String message;
  UpdatePasswordFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChangePasswordLoading extends AuthState {}

class ChangePasswordSuccess extends AuthState {
  final String message;
  ChangePasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChangePasswordFailure extends AuthState {
  final String message;
  ChangePasswordFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdateProfileLoading extends AuthState {}

class UpdateProfileSuccess extends AuthState {
  final String message;

  UpdateProfileSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdateProfileFailure extends AuthState {
  final String message;
  UpdateProfileFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

