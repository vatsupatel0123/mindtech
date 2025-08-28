import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/config/appnetwork_image.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/appointment/appointment_bloc.dart';
import 'package:mindtech/blocs/appointment/appointment_event.dart';
import 'package:mindtech/blocs/appointment/appointment_state.dart';
import 'package:mindtech/blocs/expert/expert_bloc.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/expert/expert_state.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/screens/widgets/app_rating.dart';

class ExpertAppoinmentItem extends StatelessWidget {
  final AppointmentModel appointment;
  final int status;
  const ExpertAppoinmentItem({super.key,required this.appointment, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: AppSize.screenSpacing,right: AppSize.screenSpacing,bottom: AppSize.s15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,3))],
      ),
      child: Stack(
        children: [
          if(status == 0)Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(top: AppSize.s8, right: AppSize.s8),
              padding: EdgeInsets.symmetric(vertical: AppSize.s3, horizontal: AppSize.s10),
              decoration: BoxDecoration(
                color: appointment.status == 2 ?AppColor.danger:AppColor.warning,
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
              child: Text(
                appointment.status == 2 ?"Rejected":"Upcoming",
                style: AppTextStyle.h5.copyWith(fontSize: AppSize.s10, color: appointment.status == 2 ?AppColor.white:AppColor.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.s10,vertical: AppSize.s7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.grayBorder),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: AppNetworkImage(
                          imageUrl:appointment.user!.photo ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    AppSpacing(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.user!.fullName ?? '',
                            style: AppTextStyle.h3,
                          ),
                          Text(
                            appointment.appointmentDate!.toLocalDate(),
                            style: AppTextStyle.h5,
                          ),
                          Text(
                            appointment.appointmentTime!.toLocalTime(),
                            style: AppTextStyle.h5,
                          ),
                          AppSpacing(height: 10,),
                          if(status == 0 && appointment.status == 0)Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        double rating = 0; // store user rating
                                        TextEditingController reasonController = TextEditingController();
                                        final _formKey = GlobalKey<FormState>();
                                        return AlertDialog(
                                          backgroundColor: AppColor.white,
                                          contentPadding: EdgeInsets.symmetric(horizontal: AppSize.s15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppSize.s5)
                                          ),
                                          title: Text('Reject', style: AppTextStyle.h2),
                                          titlePadding: EdgeInsets.symmetric(horizontal: AppSize.s15,vertical: AppSize.s10),
                                          content: Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  controller: reasonController,
                                                  maxLines: 3,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppColor.textfieldBorder,
                                                        width: AppSize.s1,
                                                      ),
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(AppSize.s3),
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppColor.textfieldBorder,
                                                        width: AppSize.s1,
                                                      ),
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(AppSize.s3),
                                                      ),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppColor.textfieldBorder,
                                                        width: AppSize.s1,
                                                      ),
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(AppSize.s3),
                                                      ),
                                                    ),
                                                    focusedErrorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppColor.textfieldBorder,
                                                        width: AppSize.s1,
                                                      ),
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(AppSize.s3),
                                                      ),
                                                    ),
                                                    disabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppColor.textfieldBorder,
                                                        width: AppSize.s1,
                                                      ),
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(AppSize.s3),
                                                      ),
                                                    ),
                                                    hintText: "Write your reject reason here...",
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.trim().isEmpty) {
                                                      return "Reject reason cannot be empty";
                                                    }
                                                    final wordCount = value.trim().split(RegExp(r'\s+')).length;
                                                    if (wordCount < 3) {
                                                      return "Please write at least 3 words";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                AppSpacing(height: AppSize.s5,),
                                              ],
                                            ),
                                          ),
                                          actionsPadding: EdgeInsets.all(AppSize.s15),
                                          actions: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: AppButton(
                                                    onTap: () => Navigator.of(context).pop(),
                                                    buttonText: 'Cancel',
                                                    height: 40,
                                                    buttonTextFontSize: AppSize.s14,
                                                    borderColor: AppColor.primary,
                                                    textColor: AppColor.primary,
                                                    buttonColor: AppColor.white,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: BlocListener<AppointmentBloc, AppointmentState>(
                                                    listener: (context, state) {
                                                      if (state is ChangeAppointmentStatusSuccess) {
                                                        CommonHelper.flutterToast(context, state.message,isSuccess: true);
                                                        context.read<ExpertBloc>().add(GetExpertAppoinmentData(limit: '5'));
                                                        context.pop();
                                                      } else if (state is ChangeAppointmentStatusFailure) {
                                                        CommonHelper.flutterToast(context, state.message);
                                                      }
                                                    },
                                                    child: BlocBuilder<AppointmentBloc, AppointmentState>(
                                                        builder: (context, state) {
                                                          return AppButton(
                                                            onTap: () async {
                                                              FocusScope.of(context).unfocus();
                                                              if(_formKey.currentState!.validate()){
                                                                context.read<AppointmentBloc>().add(
                                                                  ChangeAppointmentStatus(
                                                                    appointmentId: appointment.appointmentId!,
                                                                    status: 2,
                                                                    cancelledReason: reasonController.text,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            buttonText: 'Reject',
                                                            height: 40,
                                                            buttonColor: AppColor.red,
                                                            isLoading: state is ChangeAppointmentStatusLoading,
                                                          );
                                                        }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  buttonText: AppString.reject,
                                  height: 32,
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  borderRadius: BorderRadius.circular(AppSize.s5),
                                  buttonTextFontSize: 12,
                                  buttonColor: AppColor.white,
                                  borderColor: AppColor.red,
                                  textColor: AppColor.red,
                                ),
                              ),
                              AppSpacing(width: AppSize.s20,),
                              Expanded(
                                child: AppButton(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: AppColor.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          title: Text('Accept', style: AppTextStyle.h2),
                                          titlePadding: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s10),
                                          contentPadding: EdgeInsets.only(left: AppSize.s20,right: AppSize.s20,bottom: AppSize.s20),
                                          content: Text(
                                            'Are you sure you want to accept this session?',
                                            style: AppTextStyle.h4,
                                          ),
                                          actions: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: AppButton(
                                                    onTap: () => Navigator.of(context).pop(),
                                                    buttonText: 'Cancel',
                                                    height: 40,
                                                    buttonTextFontSize: AppSize.s14,
                                                    borderRadius: BorderRadius.circular(AppSize.s5),
                                                    borderColor: AppColor.primary,
                                                    textColor: AppColor.primary,
                                                    buttonColor: AppColor.white,
                                                  ),
                                                ),
                                                SizedBox(width: 15),

                                                Expanded(
                                                  child: BlocListener<AppointmentBloc, AppointmentState>(
                                                    listener: (context, state) {
                                                      if (state is ChangeAppointmentStatusSuccess) {
                                                        CommonHelper.flutterToast(context, state.message,isSuccess: true);
                                                        context.read<ExpertBloc>().add(GetExpertAppoinmentData(limit: '5'));
                                                        context.pop();
                                                      } else if (state is ChangeAppointmentStatusFailure) {
                                                        CommonHelper.flutterToast(context, state.message);
                                                      }
                                                    },
                                                    child: BlocBuilder<AppointmentBloc, AppointmentState>(
                                                        builder: (context, state) {
                                                        return AppButton(
                                                          onTap: () async {
                                                            context.read<AppointmentBloc>().add(
                                                              ChangeAppointmentStatus(
                                                                appointmentId: appointment.appointmentId!,
                                                                status: 1,
                                                                cancelledReason: '',
                                                              ),
                                                            );
                                                          },
                                                          buttonText: 'Accept',
                                                          height: 40,
                                                          borderRadius: BorderRadius.circular(AppSize.s5),
                                                          buttonColor: AppColor.success,
                                                          borderColor: AppColor.success,
                                                          buttonTextFontSize: AppSize.s14,
                                                          isLoading: state is ChangeAppointmentStatusLoading,
                                                        );
                                                      }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  buttonText: AppString.accept,
                                  height: 32,
                                  borderRadius: BorderRadius.circular(AppSize.s5),
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  buttonTextFontSize: 12,
                                  buttonColor: AppColor.success,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if(appointment.status == 2)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSize.s5),
                    child: Text(
                      appointment.cancelledReason ?? '',
                      style: AppTextStyle.h5.copyWith(color: AppColor.danger,fontSize: 14),
                    ),
                  ),
                if (appointment.review!=null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSize.s5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppRating(
                          rating: double.parse(appointment.review!.rating ?? '0'),
                          size: 16,
                          showValue: true,
                        ),
                        Text(
                          appointment.review!.review!,
                          style: AppTextStyle.h5,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
