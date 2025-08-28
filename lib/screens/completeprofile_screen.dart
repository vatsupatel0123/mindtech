import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/home/home_bloc.dart';
import 'package:mindtech/blocs/home/home_event.dart';
import 'package:mindtech/blocs/home/home_state.dart';
import 'package:mindtech/models/profilequestion_model.dart';

class CompleteProfileScreen extends StatefulWidget {
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  int currentStep = 0;
  int? selectedOptionId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback){
      final homebloc = context.read<HomeBloc>();
      homebloc.add(GetProfileQuestion());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.read<HomeBloc>().add(GetHomeData());
        context.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SavedProfileQuestionSuccess) {
              CommonHelper.flutterToast(this.context, state.message,isSuccess: true);
              context.read<HomeBloc>().add(GetHomeData());
              this.context.pop();
            } else if (state is GetProfileQuestionFailure) {
              CommonHelper.flutterToast(context, state.message);
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is GetProfileQuestionLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetProfileQuestionFailure) {
                return Center(child: Text(state.message));
              }

              if (state is GetProfileQuestionLoaded) {
                ProfileQuestionModel data = state.question;
                final totalSteps = data.totalSteps!;
                final currentStep = data.currentStep!; // Keep 1-based
                final displayIndex = currentStep - 1; // UI zero-based
                final progress = currentStep / totalSteps;
                final currentQuestion = data.question!;

                return Padding(
                  padding: const EdgeInsets.all(AppSize.screenSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSpacing(height: AppSize.s30),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            context.read<HomeBloc>().add(GetHomeData());
                            this.context.pop();
                          },
                          child: ImageIcon(
                            AssetImage(AppImage.ic_close),
                            size: AppSize.s18,
                          ),
                        ),
                      ),
                      Text(
                        "Step $currentStep of $totalSteps",
                        style: AppTextStyle.h3.copyWith(fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        currentQuestion.question ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.h2,
                      ),

                      const AppSpacing(height: AppSize.s20),

                      ...List.generate(currentQuestion.options!.length, (index) {
                        final option = currentQuestion.options![index];
                        final isSelected = selectedOptionId == option.optionId;

                        return GestureDetector(
                          onTap: () {
                            print("tapped");
                            setState(() {
                              selectedOptionId = option.optionId ?? 0;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 56,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColor.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option.optionText ?? '',
                                  style: AppTextStyle.h3.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, color: Colors.green),
                              ],
                            ),
                          ),
                        );
                      }),

                      const Spacer(),

                      Row(
                        children: [
                          if (currentStep > 1) // step 1 is first
                            Expanded(
                              child: AppButton(
                                height: 50,
                                buttonText: "Previous",
                                onTap: () {
                                  context.read<HomeBloc>().add(GetProfileQuestion(step: currentStep - 1));
                                },
                                buttonColor: AppColor.transparent,
                                textColor: AppColor.primary,
                                borderColor: AppColor.primary,
                              ),
                            ),
                          if (currentStep > 1) const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              height: 50,
                              onTap: () {
                                if(selectedOptionId == null){
                                  CommonHelper.flutterToast(context, "Please select an answer.");
                                }else{
                                  context.read<HomeBloc>().add(SaveProfileQuestionEvent(queId: currentQuestion.queId ?? 0,optionId: selectedOptionId!));
                                  setState(() {
                                    selectedOptionId = null;
                                  });
                                }
                              },
                              buttonText:
                              currentStep < totalSteps ? "Next" : "Finish",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
