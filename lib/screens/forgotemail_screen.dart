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

class ForgotEmailScreen extends StatefulWidget {
  const ForgotEmailScreen({super.key});

  @override
  State<ForgotEmailScreen> createState() => _ForgotEmailState();
}

class _ForgotEmailState extends State<ForgotEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

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
                if (state is ForgotEmailSuccess) {
                  context.pop();
                  CommonHelper.flutterToast(this.context, state.message,isSuccess: true);
                  this.context.push(
                    AppRoutes.otp,
                    extra: {
                      'userId': state.userId,
                      'isForgotScreen': true,
                    },
                  );

                } else if (state is ForgotEmailFailure) {
                  CommonHelper.flutterToast(context, state.message);
                }
              },
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
                  Text(AppString.forgotEmailTitle, style: AppTextStyle.h2),
                  Text(AppString.forgotEmailDesc, style: AppTextStyle.h4),
                  AppSpacing(height: AppSize.s20),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 0,
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: AppString.email_hint,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value!.validateEmail(),
                      ),
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              ForgotEmailEvent(
                                emailId: emailController.text
                              ),
                            );
                          }
                        },
                        buttonText: AppString.continue_txt,
                        isLoading: state is ForgotEmailLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


