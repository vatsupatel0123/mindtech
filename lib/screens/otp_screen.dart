import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_specing.dart' show AppSpacing;
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/common_helper.dart';
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

class OtpScreen extends StatefulWidget {
  final int userId;
  final bool isForgotScreen;
  const OtpScreen({super.key, required this.userId, this.isForgotScreen = false});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
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
                if (state is VerifyOtpSuccess) {
                  if(state.status == AppString.statusUpdatePassword){
                    this.context.go(AppRoutes.updatePassword,extra: state.userId);
                  }else{
                    this.context.go(AppRoutes.bottomNav);
                  }
                } else if (state is VerifyOtpFailure) {
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
                  Text(AppString.otp, style: AppTextStyle.h1),
                  Text(AppString.otp_desc, style: AppTextStyle.h4),
                  AppSpacing(height: AppSize.s20),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 0,
                      ),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        errorTextSpace: 22,
                        validator: (v) {
                          if (v!.length < 3) {
                            return "Please enter otp";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 60,
                          fieldWidth: 60,
                          activeFillColor: Colors.white,
                          disabledColor: Colors.white,
                          inactiveFillColor: AppColor.grayBackground,
                          inactiveColor: AppColor.grayBorder
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: false,
                        errorAnimationController: errorController,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          debugPrint("Completed");
                        },
                        onChanged: (value) {
                          debugPrint(value);
                        },
                        beforeTextPaste: (text) {
                          return true;
                        },
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
                              VerifyOtpEvent(
                                userId: widget.userId,
                                otp: otpController.text,
                                isForgotScreen: widget.isForgotScreen
                              ),
                            );
                          }
                        },
                        buttonText: AppString.continue_txt,
                        isLoading: state is VerifyOtpLoading,
                      );
                    },
                  ),
                  ResendOtpTimer(
                    seconds: 90,
                    onResend: () async {
                      context.read<AuthBloc>().add(
                        ResendOtpEvent(
                          userId: widget.userId,
                        ),
                      );
                      CommonHelper.flutterToast(context, "OTP resend successfully.",isSuccess: true);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


