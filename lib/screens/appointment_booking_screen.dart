import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/appointment/appointment_bloc.dart';
import 'package:mindtech/blocs/appointment/appointment_event.dart';
import 'package:mindtech/blocs/appointment/appointment_state.dart';
import 'package:mindtech/blocs/expert/expert_bloc.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/expert/expert_state.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/expert_slot_model.dart';
import 'package:mindtech/models/package_model.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final ExpertModel experts;
  const AppointmentBookingScreen({Key? key,required this.experts}) : super(key: key);

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  int currentStep = 0;
  int selectedIndex = -1;
  int selectedPackageIndex = 0;
  String selectedSession = '';
  int selectedPrice = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool consentGiven = false;

  void _showError(String message) {
    CommonHelper.flutterToast(context, message);
  }

  /// Validate current step. Returns true when validation passes.
  bool _validateCurrentStep(ExpertAppointmentSlotsLoaded slotsState) {
    if (currentStep == 0) {
      if (selectedTimeIndex < 0) {
        _showError("Please select a time slot");
        return false;
      }
      return true;
    }

    if (currentStep == 1) {
      if (selectedPackageIndex < 0 || selectedPackageIndex >= slotsState.packages.length) {
        _showError("Please select a package");
        return false;
      }
      return true;
    }

    return true;
  }

  void onPrevious() {
    setState(() {
      selectedIndex = -1;
      if (currentStep > 0) currentStep--;
    });
  }
// Replace your existing onNext() and onFinish() with these:
  void onNext(ExpertAppointmentSlotsLoaded slotsState) {
    if (!_validateCurrentStep(slotsState)) return;

    setState(() {
      selectedIndex = -1;
      if (currentStep < 2) currentStep++;
    });
  }

  void onFinish(ExpertAppointmentSlotsLoaded slotsState) {
    FocusScope.of(context).unfocus();
    if(_formKey.currentState!.validate()){
      if (!_validateCurrentStep(slotsState)) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColor.white,
          title: Text('Booking Confirmed', style: AppTextStyle.h2),
          content: Text(
            'Your booking for Audio Session Free is confirmed.',
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
                    borderColor: AppColor.primary,
                    textColor: AppColor.primary,
                    buttonColor: AppColor.white,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: AppButton(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                      context.read<AppointmentBloc>().add(
                        SavedAppointmentEvent(
                          expertId: widget.experts.expertId!,
                          slotId: selectedDateIndex==-1?slotsState.dateSlots[selectedTimeIndex].slotId??0:slotsState.slots[selectedDateIndex].slots![selectedTimeIndex].slotId??0,
                          packageId: slotsState.packages[selectedPackageIndex].packageId ?? 0,
                          contactNo: mobileController.text,
                          contactEmail: emailController.text,
                        )
                      );
                    },
                    buttonText: 'Confirm',
                    height: 40,
                    buttonColor: AppColor.success,
                    borderColor: AppColor.success,
                    buttonTextFontSize: AppSize.s14,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  int selectedDateIndex = 0;
  int selectedTimeIndex = -1;
  DateTime? selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      final bloc = context.read<AppointmentBloc>();
      bloc.add(GetExpertAppointmentSlots(expertId: widget.experts.expertId ?? 0));
    });
  }


  @override
  Widget build(BuildContext context) {
    final totalSteps = 3;
    final progress = (currentStep + 1) / totalSteps;

    return WillPopScope(
      onWillPop: () async {
        context.read<AppointmentBloc>().add(GetAppointmentData());
        context.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSize.screenSpacing),
            child: BlocListener<AppointmentBloc, AppointmentState>(
              listener: (context, state) {
                if (state is SaveAppointmentSuccess) {
                  CommonHelper.flutterToast(context, state.message,isSuccess: true);
                  this.context.go(AppRoutes.bottomNav);
                } else if (state is SaveAppointmentFailure) {
                  CommonHelper.flutterToast(context, state.message);
                }
              },
              child: BlocBuilder<AppointmentBloc, AppointmentState>(
                  builder: (context, state) {
                    if (state is SaveAppointmentLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is AppointmentLoading) {
                    return Center(child: CircularProgressIndicator());
                    } else
                      if (state is ExpertAppointmentSlotsLoaded) {
                        return Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  context.read<AppointmentBloc>().add(GetAppointmentData());
                                  context.pop();
                                },
                                child: ImageIcon(
                                  AssetImage(AppImage.ic_close),
                                  size: AppSize.s18,
                                ),
                              ),
                            ),
                            Text(
                              "Step ${currentStep + 1} of $totalSteps",
                              style: AppTextStyle.h3.copyWith(fontWeight: FontWeight.w300),
                            ),
                            const AppSpacing(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                              ),
                            ),
                            const AppSpacing(height: AppSize.s20),

                            if (currentStep == 0)
                              Text(
                                "We’re almost there! Choose your preferred slot.",
                                style: AppTextStyle.h2,
                                textAlign: TextAlign.center,
                              ),
                            if (currentStep == 1)
                              Text(
                                "Thank you for sharing. What mode do you prefer?",
                                style: AppTextStyle.h2,
                                textAlign: TextAlign.center,
                              ),
                            if (currentStep == 2)
                              Text(
                                "Please review and confirm your appointment preference",
                                style: AppTextStyle.h2,
                                textAlign: TextAlign.center,
                              ),

                            if (currentStep == 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSpacing(height: AppSize.s10),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () async {
                                        DateTime now = DateTime.now();
                                        List<DateTime> sortedAvailable = state.availableDates.toList()..sort();

                                        DateTime initialDate;
                                        if (selectedDate != null) {
                                          // If a date was already selected, reopen with that date
                                          initialDate = selectedDate!;
                                        } else {
                                          // Otherwise, pick the first available future date
                                          initialDate = sortedAvailable.firstWhere(
                                                (date) => !date.isBefore(now),
                                            orElse: () => now,
                                          );
                                        }

                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: initialDate,
                                          firstDate: now,
                                          lastDate: now.add(const Duration(days: 365)),
                                          selectableDayPredicate: (day) {
                                            return state.availableDates.any((d) =>
                                            d.year == day.year &&
                                                d.month == day.month &&
                                                d.day == day.day);
                                          },
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            selectedDate = picked;
                                            selectedDateIndex = state.slots.indexWhere((slot) {
                                              final slotDate = DateTime.parse(slot.slotDate.toString()).toLocal();
                                              return slotDate.year == picked.year &&
                                                  slotDate.month == picked.month &&
                                                  slotDate.day == picked.day;
                                            });
                                            if(selectedDateIndex == -1){
                                              context.read<AppointmentBloc>().add(GetExpertAppointmentSlotsByDate(expertId: widget.experts.expertId ?? 0, date: selectedDate!));
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: selectedDate == null ? AppColor.white :AppColor.primary,
                                          borderRadius: BorderRadius.circular(AppSize.s5),
                                          border: Border.all(color: AppColor.primary)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: AppSize.s20,vertical: AppSize.s8),
                                        child: Text(
                                          selectedDate == null
                                              ? "Select from Calendar"
                                              : DateFormat('dd MMM yyyy').format(selectedDate!),
                                          style: AppTextStyle.h5.copyWith(color: selectedDate == null ? AppColor.primary : AppColor.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AppSpacing(height: AppSize.s15),
                                  SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.slots.length,
                                      itemBuilder: (context, index) {
                                        ExpertSlotModel day = state.slots[index];
                                        final isSelected = selectedDateIndex == index;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedDateIndex = index;
                                              selectedTimeIndex = -1;
                                              selectedDate = null;
                                            });
                                          },
                                          child: Container(
                                            width: 90,
                                            margin: const EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              color: isSelected ? AppColor.primary : Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  day.slotDate!.toDayText(), // Mon, Tue
                                                  style: AppTextStyle.h5.copyWith(
                                                    color: isSelected ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                                const AppSpacing(height: 4),
                                                Text(
                                                  day.slotDate!.toDayLabel(),
                                                  style: AppTextStyle.h4.copyWith(
                                                    fontSize: 12,
                                                    color: isSelected ? Colors.white : Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const AppSpacing(height: 20),

                                  // Time Slot Grid for selected date
                                  if (selectedDateIndex != null && selectedDateIndex >= 0 && selectedDateIndex < state.slots.length)
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: List.generate(
                                        state.slots[selectedDateIndex].slots!.length,
                                            (index) {
                                          SlotsModel slot = state.slots[selectedDateIndex].slots![index];

                                          final isDisabled = slot.isBooked;
                                          final isSelected = selectedTimeIndex >= 0 && selectedTimeIndex == index;


                                          return GestureDetector(
                                            onTap: isDisabled!
                                                ? null
                                                : () => setState(() => selectedTimeIndex = index),
                                            child: Container(
                                              width: 100,
                                              height: 45,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: isDisabled ? Colors.grey.shade300
                                                    : isSelected
                                                    ? AppColor.primary
                                                    : Colors.white,
                                                border: Border.all(
                                                  color: isDisabled
                                                      ? Colors.grey.shade300
                                                      : Colors.grey.shade400,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                slot.slotTime!.toLocalTime(),
                                                style: AppTextStyle.h5.copyWith(
                                                  color: isDisabled
                                                      ? Colors.grey
                                                      : (isSelected ? Colors.white : Colors.black),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  if (selectedDateIndex == -1)
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(
                                      state.dateSlots.length,
                                          (index) {
                                        final slot = state.dateSlots[index];
                                        final isDisabled = slot.isBooked ?? false;
                                        final isSelected = selectedTimeIndex == index;
                                        return GestureDetector(
                                          onTap: isDisabled
                                              ? null
                                              : () => setState(() => selectedTimeIndex = index),
                                          child: Container(
                                            width: 100,
                                            height: 45,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: isDisabled
                                                  ? Colors.grey.shade300
                                                  : isSelected
                                                  ? AppColor.primary
                                                  : Colors.white,
                                              border: Border.all(
                                                color: isDisabled
                                                    ? Colors.grey.shade300
                                                    : Colors.grey.shade400,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              slot.slotTime!.toLocalTime(),
                                              style: AppTextStyle.h5.copyWith(
                                                color: isDisabled
                                                    ? Colors.grey
                                                    : (isSelected ? Colors.white : Colors.black),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                            if (currentStep == 1)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSpacing(height: 20),
                                  ...List.generate(state.packages.length, (index) {
                                    final pkg = state.packages[index];
                                    final isSelected = selectedPackageIndex == index;

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: index == state.packages.length - 1 ? 0 : 16),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedPackageIndex = index;
                                          });
                                        },
                                        child: ModeCard(
                                          isSelected: isSelected,
                                          mode: pkg.packageTitle ?? "", // package_title
                                          duration: "Duration: For initial ${pkg.duration}*",
                                          oldPrice: "₹${pkg.netAmount}",  // net_amount from API
                                          newPrice: pkg.originalAmount == 0 ? "Free" : "₹${pkg.originalAmount}",
                                          description: pkg.packageDesc ?? "",
                                          icon: pkg.packageTitle?.toLowerCase().contains("video") == true
                                              ? Icons.videocam
                                              : Icons.phone,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),

                            if (currentStep == 2)
                              Expanded(
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppSpacing(height: AppSize.s20),
                                          _infoRow("Expert", widget.experts.expertName ?? ''),
                                          _infoRow("Mode", state.packages[selectedPackageIndex].packageTitle ?? ''),
                                          _infoRow("Date", selectedDateIndex==-1?selectedDate!.toString().toLocalDate():state.slots[selectedDateIndex].slotDate!.toLocalDate()),
                                          _infoRow("Time", selectedDateIndex==-1?state.dateSlots[selectedTimeIndex].slotTime!.toLocalTime():state.slots[selectedDateIndex].slots![selectedTimeIndex].slotTime!.toLocalTime()),
                                          _infoRow("Charges", state.packages[selectedPackageIndex].originalAmount == 0 ? "Free" : "₹${state.packages[selectedPackageIndex].originalAmount}"),
                                          AppSpacing(height: AppSize.s10),
                                          Text("Please provide at least one contact details:",style: AppTextStyle.h4.copyWith(color: Colors.black54),),
                                          AppSpacing(height: AppSize.s10),
                                          TextFormField(
                                            controller: mobileController,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                              labelText: 'Enter Contact Number',
                                            ),
                                            validator: (value) {
                                              if ((value == null || value.isEmpty) &&
                                                  (emailController.text.isEmpty)) {
                                                return 'Please provide at least one contact details';
                                              }
                                              return null;
                                            },
                                          ),
                                          AppSpacing(height: AppSize.s20,),
                                          TextFormField(
                                            controller: emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              labelText: 'Enter Contact Email',
                                            ),
                                            validator: (value) {
                                              if ((value == null || value.isEmpty) &&
                                                  (mobileController.text.isEmpty)) {
                                                return 'Please provide at least one contact details';
                                              }
                                              return null;
                                            },
                                          ),
                                          // AppSpacing(height: AppSize.s20),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //   children: [
                                          //     SizedBox(
                                          //       width: 20,
                                          //       height: 20,
                                          //       child: Checkbox(
                                          //         value: consentGiven,
                                          //         onChanged: (value) {
                                          //           setState(() {
                                          //             consentGiven = value!;
                                          //           });
                                          //         },
                                          //       ),
                                          //     ),
                                          //     AppSpacing(width: AppSize.s20,),
                                          //     Expanded(
                                          //       child: RichText(
                                          //         text: TextSpan(
                                          //           text:
                                          //           'I hereby consent to the session being recorded for purposes set out in the ',
                                          //           style: AppTextStyle.h5.copyWith(
                                          //               color: Colors.black),
                                          //           children: [
                                          //             TextSpan(
                                          //               text: 'Privacy Policy',
                                          //               style: AppTextStyle.h5.copyWith(
                                          //                   color: Colors.blue,
                                          //                   decoration: TextDecoration.underline),
                                          //             ),
                                          //             TextSpan(
                                          //               text:
                                          //               '. Information shared during the session is confidential unless otherwise provided in the ',
                                          //             ),
                                          //             TextSpan(
                                          //               text: 'Terms and Conditions.',
                                          //               style: AppTextStyle.h5.copyWith(
                                          //                   color: Colors.blue,
                                          //                   decoration: TextDecoration.underline),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          AppSpacing(height: AppSize.s20,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (currentStep != 2)Spacer(),
                            Row(
                              children: [
                                if (currentStep > 0)
                                  Expanded(
                                    child: AppButton(
                                      height: 50,
                                      buttonText: "Previous",
                                      onTap: onPrevious,
                                      buttonColor: AppColor.transparent,
                                      textColor: AppColor.primary,
                                      borderColor: AppColor.primary,
                                    ),
                                  ),
                                if (currentStep > 0) const AppSpacing(width: 12),
                                Expanded(
                                  child: AppButton(
                                    height: 50,
                                    onTap: currentStep == totalSteps - 1
                                        ? () => onFinish(state)          // state is ExpertSlotsLoaded (in this branch)
                                        : () => onNext(state),
                                    buttonText:
                                    currentStep == totalSteps - 1 ? "Confirm & Book" : "Next",
                                    isLoading: state is SaveAppointmentLoading,
                                  ),
                                ),
                              ],
                            ),
                          ],
                                              ),
                        );
                    } else if (state is AppointmentFailure) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => context.pop(true),
                              child: ImageIcon(
                                AssetImage(AppImage.ic_close),
                                size: AppSize.s18,
                              ),
                            ),
                          ),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(bottom: AppSize.s30),
                            child: Center(child: Text(state.message)),
                          )),
                        ],
                      );
                    }
                    return Container();

                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: AppTextStyle.h4.copyWith(color: Colors.black54),),
          Text(
              value,
              style: AppTextStyle.h3
          ),
        ],
      ),
    );
  }
}

class ModeCard extends StatelessWidget {
  final String mode;
  final String duration;
  final String oldPrice;
  final String newPrice;
  final String description;
  final IconData icon;
  final bool isSelected;

  const ModeCard({
    super.key,
    required this.mode,
    required this.duration,
    required this.oldPrice,
    required this.newPrice,
    required this.description,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColor.primary : Colors.transparent,
          width: 2,
        ),
        boxShadow: [BoxShadow(color: AppColor.gray, blurRadius: 5)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSize.s10,
          horizontal: AppSize.s15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      oldPrice,
                      style: AppTextStyle.h5.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: AppSize.s12,
                      ),
                    ),
                    Text(
                      newPrice,
                      style: AppTextStyle.h2.copyWith(
                        fontSize: AppSize.s22,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
                AppSpacing(width: AppSize.s40),
                Expanded(
                  child: Column(
                    children: [
                      Text(mode, style: AppTextStyle.h3),
                      Text(
                        duration,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.h5,
                      ),
                      const AppSpacing(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              description,
              style: AppTextStyle.h5.copyWith(
                fontSize: AppSize.s13,
                color: AppColor.black.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
