import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/config/appnetwork_image.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/appointment/appointment_bloc.dart';
import 'package:mindtech/blocs/appointment/appointment_event.dart';
import 'package:mindtech/blocs/expert/expert_bloc.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/expert/expert_state.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/screens/widgets/app_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppointmentItem extends StatelessWidget {
  final AppointmentModel appointment;
  const AppointmentItem({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: AppSize.s10,),
          if (appointment.isUpcoming ?? false)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(right: AppSize.s5),
                padding: EdgeInsets.symmetric(vertical: AppSize.s3, horizontal: AppSize.s10),
                decoration: BoxDecoration(
                  color: AppColor.warning,
                  borderRadius: BorderRadius.circular(AppSize.s10),
                ),
                child: Text(
                  "Upcoming",
                  style: AppTextStyle.h5.copyWith(fontSize: AppSize.s10, color: AppColor.black),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSize.s10,
                      ),
                      child: AppNetworkImage(
                        imageUrl:appointment.expert!.photo ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    AppSpacing(width: 40),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            appointment.expert!.expertName ?? '',
                            style: AppTextStyle.h3,
                          ),
                          Text(
                            appointment.expert!.qualification ?? '',
                            style: AppTextStyle.h5,
                          ),
                          AppSpacing(height: AppSize.s10),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: AppSize.s15,
                                  ),
                                  AppSpacing(width: AppSize.s5),
                                  Text(
                                    appointment.appointmentDate!.toLocalDate(),
                                    style: AppTextStyle.h5.copyWith(
                                      fontSize: AppSize.s12,
                                    ),
                                  ),
                                ],
                              ),
                              AppSpacing(width: AppSize.s20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: AppSize.s15,
                                  ),
                                  AppSpacing(width: AppSize.s5),
                                  Text(
                                    appointment.appointmentTime!.toLocalTime(),
                                    style: AppTextStyle.h5.copyWith(
                                      fontSize: AppSize.s12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing(height: AppSize.s10),
                // After date/time row
                if ((appointment.isUpcoming ?? false) && appointment.appointmentUrl!=null)
                  AppButton(
                    onTap: () async{
                      final Uri url = Uri.parse(appointment.appointmentUrl!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication, // Opens in browser or native app
                        );
                      } else {
                        print("Could not launch $url");
                      }
                    },
                    buttonText: "Join Call",
                    buttonColor: AppColor.white,
                    borderColor: AppColor.secondery,
                    textColor: AppColor.secondery,
                  ),

                if (appointment.review==null && !(appointment.isUpcoming ?? false))
                  AppButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          double rating = 0; // store user rating
                          TextEditingController reviewController = TextEditingController();
                          final _formKey = GlobalKey<FormState>();
                          return AlertDialog(
                            backgroundColor: AppColor.white,
                            contentPadding: EdgeInsets.symmetric(horizontal: AppSize.s15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSize.s5)
                            ),
                            title: Text('Write a Review', style: AppTextStyle.h2),
                            titlePadding: EdgeInsets.symmetric(horizontal: AppSize.s15,vertical: AppSize.s10),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    glow: false,
                                    unratedColor: AppColor.grayBorder,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (value) {
                                      rating = value;
                                    },
                                    updateOnDrag: true,
                                  ),
                                  AppSpacing(height: AppSize.s10,),
                                  TextFormField(
                                    controller: reviewController,
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
                                      hintText: "Write your review here...",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return "Review cannot be empty";
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
                                    child: BlocListener<ExpertBloc, ExpertState>(
                                      listener: (context, state) {
                                        if (state is SavedExpertReviewSuccess) {
                                          CommonHelper.flutterToast(context, state.message,isSuccess: true);
                                          context.read<AppointmentBloc>().add(GetAppointmentData());
                                          context.pop();
                                        } else if (state is SavedExpertReviewFailure) {
                                          CommonHelper.flutterToast(context, state.message);
                                        }
                                      },
                                      child: BlocBuilder<ExpertBloc, ExpertState>(
                                          builder: (context, state) {
                                          return AppButton(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();
                                              if(_formKey.currentState!.validate()){
                                                if(rating == 0){
                                                  CommonHelper.flutterToast(
                                                    context,
                                                    "Please select a rating out of 5 stars",
                                                    isSuccess: false, // optional: to show as error style
                                                  );
                                                  return;
                                                }else{
                                                  context.read<ExpertBloc>().add(
                                                    SavedExpertReview(
                                                      expertId: appointment.expert!.expertId!,
                                                      appointmentId: appointment.appointmentId!,
                                                      rating: rating.toInt(),
                                                      review: reviewController.text,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            buttonText: 'Submit',
                                            height: 40,
                                            isLoading: state is SavedExpertReviewLoading,
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
                    buttonText: "Write a review",
                    buttonColor: AppColor.white,
                    borderColor: AppColor.green_light,
                    textColor: AppColor.green_light,
                  ),

                if (appointment.status == 2)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.cancelledReason ?? '',
                        style: AppTextStyle.h5.copyWith(color: AppColor.danger,fontSize: 14),
                      ),
                      AppSpacing(height: AppSize.s5,),
                      AppButton(
                        onTap: () {
                          context.push(
                            AppRoutes.appointmentBooking,
                            extra: appointment.expert,
                          );
                        },
                        buttonText: "Reschedule",
                      ),
                    ],
                  ),

                if (appointment.review!=null)
                  Column(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
