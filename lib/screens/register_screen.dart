import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/auth/auth_bloc.dart';
import 'package:mindtech/blocs/auth/auth_event.dart';
import 'package:mindtech/blocs/auth/auth_state.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  final bool isGoogle;
  final UserCredential? user;
  const RegisterScreen({super.key, this.isGoogle = false, this.user});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

enum Gender { male, female, other }

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  Gender? _selectedGender;
  bool agree = false;
  DateTime? selectedDob;
  late bool isGoogle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isGoogle = widget.isGoogle;
    if(isGoogle){
      nameController.text = widget.user!.user!.displayName ?? '';
      emailController.text = widget.user!.user!.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.screenSpacing,
          ),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                if(state.status == AppString.statusLogin){
                  this.context.go(AppRoutes.bottomNav);
                }else if(state.status == AppString.statusOtpSent){
                  CommonHelper.flutterToast(context, state.message,isSuccess: true);
                  context.pop();
                  this.context.push(AppRoutes.otp, extra: {
                    'userId': state.userId,
                  });
                }else{
                  CommonHelper.flutterToast(context, state.message);
                }
              } else if (state is RegisterFailure) {
                CommonHelper.flutterToast(context, state.message);
              }
              if (state is GoogleRegisterSuccess) {
                this.context.go(AppRoutes.bottomNav);
              } else if (state is GoogleRegisterFailure) {
                CommonHelper.flutterToast(context, state.message);
              }
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing(height: AppSize.s20),
                    Text(isGoogle?AppString.complete_profile:AppString.register, style: AppTextStyle.h1),
                    Text(AppString.register_desc, style: AppTextStyle.h4),
                    AppSpacing(height: AppSize.s40),
                    Row(
                      children: [
                        if(!isGoogle)Expanded(
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: AppString.name_hint,
                            ),
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            validator: (value) => value!.validateEmpty(AppString.name_hint),
                          ),
                        ),
                        if(!isGoogle)SizedBox(width: AppSize.s10,),
                        Expanded(
                          child: TextFormField(
                            controller: ageController,
                            decoration: InputDecoration(
                              hintText: AppString.age,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value!.validateEmpty(AppString.age_hint),
                          ),
                        ),
                      ],
                    ),
                    // AppSpacing(height: AppSize.s15),
                    // TextFormField(
                    //   controller: mobileController,
                    //   decoration: InputDecoration(
                    //     hintText: AppString.mobile_no_hint,
                    //   ),
                    //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    //   keyboardType: TextInputType.phone,
                    //   validator: (value) => value!.validatePhoneNumber(),
                    // ),
                    AppSpacing(height: AppSize.s15),
                    FormField<Gender>(
                      validator: (value) {
                        if (_selectedGender == null) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                      builder: (FormFieldState<Gender> field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height:20,
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Radio<Gender>(
                                        value: Gender.male,
                                        groupValue: _selectedGender,
                                        onChanged: (Gender? value) {
                                          setState(() {
                                            _selectedGender = value;
                                            field.didChange(value); // Update form state
                                          });
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedGender = Gender.male;
                                            field.didChange(Gender.male);
                                          });
                                        },
                                        child: const Text('Male'),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio<Gender>(
                                        value: Gender.female,
                                        groupValue: _selectedGender,
                                        onChanged: (Gender? value) {
                                          setState(() {
                                            _selectedGender = value;
                                            field.didChange(value);
                                          });
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedGender = Gender.female;
                                            field.didChange(Gender.female);
                                          });
                                        },
                                        child: const Text('Female'),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio<Gender>(
                                        value: Gender.other,
                                        groupValue: _selectedGender,
                                        onChanged: (Gender? value) {
                                          setState(() {
                                            _selectedGender = value;
                                            field.didChange(value);
                                          });
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedGender = Gender.other;
                                            field.didChange(Gender.other);
                                          });
                                        },
                                        child: const Text('Other'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: AppSize.s15,top: AppSize.s3),
                                child: Text(
                                  field.errorText!,
                                  style: AppTextStyle.error,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    AppSpacing(height: AppSize.s15),
                    TextFormField(
                      controller: languageController,
                      decoration: InputDecoration(
                        hintText: AppString.preferred_language,
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.validateEmpty(AppString.name_hint),
                    ),
                    AppSpacing(height: AppSize.s15),
                    TextFormField(
                      controller: occupationController,
                      decoration: InputDecoration(
                        hintText: AppString.occupation,
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                    ),
                    if(!isGoogle)AppSpacing(height: AppSize.s15),
                    if(!isGoogle)TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: AppString.email_hint,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.validateEmail(),
                    ),
                    if(!isGoogle)AppSpacing(height: AppSize.s15),
                    if(!isGoogle)TextFormField(
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
                    if(!isGoogle)AppSpacing(height: AppSize.s15),
                    if(!isGoogle)TextFormField(
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
                    AppSpacing(height: AppSize.s5),
                    FormField<bool>(
                      validator: (value) {
                        if (!agree) {
                          return 'You must agree to continue';
                        }
                        return null;
                      },
                      builder: (FormFieldState<bool> field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: agree,
                                  onChanged: (val) {
                                    setState(() {
                                      agree = val ?? false;
                                      field.didChange(val);
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Wrap(
                                    children: [
                                      const Text('I agree to the '),
                                      GestureDetector(
                                        onTap: () {
                                          // Open Privacy Policy
                                          launchUrl(Uri.parse(AppString.privacyPolicyUrl));
                                        },
                                        child: const Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      const Text(' and '),
                                      GestureDetector(
                                        onTap: () {
                                          // Open Terms & Conditions
                                          launchUrl(Uri.parse(AppString.termsUrl));
                                        },
                                        child: const Text(
                                          'Terms & Conditions',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: AppSize.s15,),
                                child: Text(
                                  field.errorText!,
                                  style: AppTextStyle.error,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    AppSpacing(height: AppSize.s20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          onTap: () async{
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              String? notificationToken = await FirebaseMessaging.instance.getToken();
                              if(!isGoogle){
                                context.read<AuthBloc>().add(
                                  RegisterEvent(
                                      user: UserModel(
                                          fullName: nameController.text,
                                          age: ageController.text,
                                          gender: _selectedGender!.name,
                                          preferredLanguage: languageController.text,
                                          occupation: occupationController.text,
                                          emailId: emailController.text,
                                          password: passwordController.text,
                                          notificationToken: notificationToken
                                      )
                                  ),
                                );
                              }else{
                                context.read<AuthBloc>().add(
                                  GoogleRegisterEvent(
                                      user: UserModel(
                                          fullName: nameController.text,
                                          age: ageController.text,
                                          gender: _selectedGender!.name,
                                          preferredLanguage: languageController.text,
                                          occupation: occupationController.text,
                                          emailId: emailController.text,
                                          notificationToken: notificationToken
                                      )
                                  ),
                                );
                              }
                            }
                          },
                          buttonText: isGoogle?AppString.complete_profile:AppString.register,
                          isLoading: isGoogle?state is GoogleRegisterLoading:state is RegisterLoading,
                        );
                      },
                    ),
                    AppSpacing(height: AppSize.s20),
                    if(!isGoogle)Center(
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Text(
                          AppString.already_account,
                          style: AppTextStyle.h4.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if(!isGoogle)AppSpacing(height: AppSize.s20),
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
