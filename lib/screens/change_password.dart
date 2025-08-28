import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/utils/shared_preference_utility.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/auth/auth_bloc.dart';
import 'package:mindtech/blocs/auth/auth_event.dart';
import 'package:mindtech/blocs/auth/auth_state.dart';
import 'package:mindtech/screens/items/appbar_custom.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isOldObscure = true;
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  final TextEditingController oldpasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password",style: AppTextStyle.h2,),
        centerTitle: false,
        leadingWidth: 50,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.screenSpacing,
          ),
          child: Column(
            children: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    CommonHelper.flutterToast(this.context, state.message,isSuccess: true);
                    this.context.pop();
                  } else if (state is ChangePasswordFailure) {
                    CommonHelper.flutterToast(context, state.message);
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Old Password",style: AppTextStyle.h4,),
                      AppSpacing(height: AppSize.s5),
                      TextFormField(
                        controller: oldpasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _isOldObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          if (value == passwordController.text) {
                            return 'New password must be different from old password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: AppString.oldpassword_hint,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isOldObscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isOldObscure = !_isOldObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      AppSpacing(height: AppSize.s15),
                      Text("New Password",style: AppTextStyle.h4,),
                      AppSpacing(height: AppSize.s5),
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
                          hintText: AppString.newpassword_hint,
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
                      Text("Confirm New Password",style: AppTextStyle.h4,),
                      AppSpacing(height: AppSize.s5),
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
                                print(oldpasswordController.text);
                                print(passwordController.text);
                                print(confirmPasswordController.text);
                                context.read<AuthBloc>().add(
                                  ChangePasswordEvent(
                                    oldPassword: oldpasswordController.text,
                                    newPassword: passwordController.text,
                                    confirmPassword: confirmPasswordController.text,
                                  ),
                                );
                              }
                            },
                            buttonText: AppString.change_password,
                            isLoading: state is ChangePasswordLoading,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
