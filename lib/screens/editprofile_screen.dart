import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/config/appnetwork_image.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/auth/auth_bloc.dart';
import 'package:mindtech/blocs/auth/auth_event.dart';
import 'package:mindtech/blocs/auth/auth_state.dart';
import 'package:mindtech/models/user_model.dart';
import 'package:mindtech/screens/register_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Gender? _selectedGender;
  String userPhoto = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      UserModel? user = await CommonHelper.getUserData();
      nameController.text = user!.fullName ?? '';
      ageController.text = user.age ?? '';
      _selectedGender = Gender.values.firstWhere(
        (g) => g.name == (user.gender ?? '').toLowerCase(),
        orElse: () => Gender.other,
      );
      userPhoto = user.photo ?? '';
      languageController.text = user.preferredLanguage ?? '';
      occupationController.text = user.occupation ?? '';
      emailController.text = user.emailId ?? '';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: AppTextStyle.h2),
        centerTitle: false,
        leadingWidth: 50,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.screenSpacing,
          ),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UpdateProfileSuccess) {
                context.pop();
                CommonHelper.flutterToast(
                  context,
                  state.message,
                  isSuccess: true,
                );
              }
              if (state is UpdateProfileFailure) {
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
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.gray),
                                  borderRadius: BorderRadius.circular(60)
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: _selectedImage != null
                                      ? Image.file(
                                    _selectedImage!,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ):AppNetworkImage(
                                    imageUrl: userPhoto ?? '',
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showImageSourceActionSheet,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing(height: AppSize.s30),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: AppString.name_hint,
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      validator:
                          (value) => value!.validateEmpty(AppString.name_hint),
                    ),
                    AppSpacing(height: AppSize.s15),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(hintText: AppString.age),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) => value!.validateEmpty(AppString.age_hint),
                    ),
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
                              height: 20,
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
                                            field.didChange(
                                              value,
                                            ); // Update form state
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
                                padding: const EdgeInsets.only(
                                  left: AppSize.s15,
                                  top: AppSize.s3,
                                ),
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
                      validator:
                          (value) => value!.validateEmpty(AppString.name_hint),
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
                    AppSpacing(height: AppSize.s15),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: AppString.email_hint,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.validateEmail(),
                      readOnly: true,
                    ),
                    AppSpacing(height: AppSize.s20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                UpdateProfileEvent(
                                  user: UserModel(
                                    fullName: nameController.text,
                                    age: ageController.text,
                                    gender: _selectedGender!.name,
                                    preferredLanguage: languageController.text,
                                    occupation: occupationController.text,
                                  ),
                                  photo: _selectedImage,
                                ),
                              );
                            }
                          },
                          buttonText: AppString.update,
                          isLoading: state is UpdateProfileLoading,
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        if (await Permission.photos.isDenied) {
          await Permission.photos.request();
        }
      } else {
        if (await Permission.storage.isDenied) {
          await Permission.storage.request();
        }
      }

      if (await Permission.camera.isDenied) {
        await Permission.camera.request();
      }
    }
  }

  void _showImageSourceActionSheet() {
    _requestPermissions();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
