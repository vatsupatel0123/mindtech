import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_specing.dart' show AppSpacing;
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/blocs/auth/auth_event.dart';
import 'package:mindtech/screens/widgets/resend_otp.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/auth/auth_bloc.dart';
import 'package:mindtech/blocs/auth/auth_state.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final int userId;
  const UpdatePasswordScreen({super.key, required this.userId});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.screenSpacing,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is UpdatePasswordSuccess) {
                  CommonHelper.flutterToast(this.context, state.message,isSuccess: true);
                  this.context.go(AppRoutes.login);
                } else if (state is UpdatePasswordFailure) {
                  CommonHelper.flutterToast(context, state.message);
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing(height: AppSize.s40,),
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(AppImage.otpGifImage),
                        ),
                      ),
                    ),
                    AppSpacing(height: AppSize.s10,),
                    Text(AppString.updatePasswordTitle, style: AppTextStyle.h2),
                    Text(AppString.updatePasswordDesc, style: AppTextStyle.h4),
                    AppSpacing(height: AppSize.s20),
                    AppSpacing(height: AppSize.s15),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isObscure,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppString.password_hint,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    AppSpacing(height: AppSize.s15),
                    TextFormField(
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isConfirmObscure,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppString.confirm_password_hint,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmObscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmObscure = !_isConfirmObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    AppSpacing(height: AppSize.s20,),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                UpdatePasswordEvent(
                                  userId: widget.userId.toString(),
                                  newPassword: passwordController.text,
                                  confirmPassword: confirmPasswordController.text,
                                ),
                              );
                            }
                          },
                          buttonText: AppString.continue_txt,
                          isLoading: state is UpdatePasswordLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


