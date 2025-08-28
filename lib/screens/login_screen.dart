import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindtech/app/config/app_specing.dart' show AppSpacing;
import 'package:mindtech/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/auth/auth_bloc.dart';
import 'package:mindtech/blocs/auth/auth_event.dart';
import 'package:mindtech/blocs/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                if(state.status == AppString.statusLogin){
                  Provider.of<UserProvider>(context,listen: false).loadUserData();
                  if(state.type == AppString.statusUserType){
                    this.context.go(AppRoutes.bottomNav);
                  }else{
                    this.context.go(AppRoutes.expertBottomNav);
                  }
                }else if(state.status == AppString.statusOtpSent){
                  CommonHelper.flutterToast(context, state.message,isSuccess: true);
                  this.context.push(AppRoutes.otp, extra: {
                    'userId': state.userId,
                  });
                }else{
                  CommonHelper.flutterToast(context, state.message);
                }

              } else if (state is AuthFailure) {
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
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: Image.asset(
                        AppImage.login_img,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  AppSpacing(height: AppSize.s20,),
                  Flexible(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing(height: AppSize.s10),
                        Text(AppString.login, style: AppTextStyle.h1),
                        AppSpacing(height: AppSize.s10),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: AppString.email_hint,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value!.validateEmail(),
                        ),
                        SizedBox(height: AppSize.s15),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) => value!.validatePassword(),
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            hintText: AppString.password_hint,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure; // Toggle obscureText
                                });
                              },
                            ),
                          ),
                        ),
                        AppSpacing(height: AppSize.s10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: (){
                              context.push(AppRoutes.forgotemail);
                            },
                            child: Text(
                              AppString.forgot_password,
                              style: AppTextStyle.h5,
                            ),
                          ),
                        ),
                        AppSpacing(height: AppSize.s20),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AppButton(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    LoginEvent(
                                      emailId: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                                }
                              },
                              buttonText: AppString.login,
                              isLoading: state is AuthLoading,
                            );
                          },
                        ),
                        AppSpacing(height: AppSize.s40),
                        Center(
                          child: GestureDetector(
                            onTap: (){
                              context.push(AppRoutes.register);
                            },
                            child: Text(
                              AppString.create_account,
                              style: AppTextStyle.h4.copyWith(
                                color: AppColor.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        AppSpacing(height: AppSize.s20),
                        Center(child: Text(AppString.or, style: AppTextStyle.h4)),
                        AppSpacing(height: AppSize.s20),
                        BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            print(state);
                            if (state is GoogleLoginSuccess) {
                              if(state.status == AppString.statusLogin){
                                this.context.go(AppRoutes.bottomNav);
                              }else if(state.status == AppString.statusIncomplete){
                                this.context.push(AppRoutes.register, extra: state.user);
                              }else{
                                CommonHelper.flutterToast(context, state.message);
                              }

                            } else if (state is GoogleLoginFailure) {
                              CommonHelper.flutterToast(context, state.message);
                            }
                          },
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(double.infinity, 50),
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                                icon: state is GoogleLoginLoading
                                ? Container():Image.asset(
                                  AppImage.ic_google,
                                  height: 24,
                                  width: 24,
                                ),
                                label: state is GoogleLoginLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : Text(
                                  'Continue with Google',
                                  style: AppTextStyle.h3.copyWith(fontWeight: FontWeight.w600),
                                ),
                                onPressed: () async {
                                  context.read<AuthBloc>().add(
                                    GoogleLoginEvent(),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                      ],
                    ),
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


