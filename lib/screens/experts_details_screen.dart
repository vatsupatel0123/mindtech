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
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/expert/expert_bloc.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/expert/expert_state.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/models/review_model.dart';
import 'package:mindtech/screens/items/appbar_custom.dart';
import 'package:mindtech/screens/items/expert_item.dart';
import 'package:mindtech/screens/items/review_item.dart';
import 'package:mindtech/screens/widgets/app_rating.dart';

class ExpertsDetailsScreen extends StatefulWidget {
  final ExpertModel experts;

  const ExpertsDetailsScreen({super.key, required this.experts});

  @override
  State<ExpertsDetailsScreen> createState() => _ExpertsDetailsScreenState();
}

class _ExpertsDetailsScreenState extends State<ExpertsDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) => ExpertBloc()..add(GetExpertDetails(expertId: widget.experts.expertId ?? 0)),
          child: BlocBuilder<ExpertBloc, ExpertState>(
            builder: (context, state) {
              if (state is ExpertLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ExpertDetailsLoaded) {
                ExpertModel expert = state.expert;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.screenSpacing,
                      ),
                      child: Column(
                        children: [
                          AppSpacing(height: AppSize.s20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: AppNetworkImage(
                                  imageUrl: expert.photo ?? '',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              AppSpacing(width: AppSize.s40),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expert.expertName ?? '',
                                      style: AppTextStyle.h3,
                                    ),
                                    Text(
                                      expert.qualification ?? '',
                                      style: AppTextStyle.h5,
                                    ),
                                    AppSpacing(height: 6),
                                    AppRating(
                                      rating: double.parse(
                                        expert.avgRating ?? "0",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => context.pop(true),
                                icon: ImageIcon(
                                  AssetImage(AppImage.ic_close),
                                  size: AppSize.s16,
                                ),
                                iconSize: 16,
                                padding: EdgeInsets.zero,
                                alignment: Alignment.topRight,
                              )
                            ],
                          ),
                          AppSpacing(height: AppSize.s20),
                          Row(
                            children: [
                              Text(
                                "Experience:",
                                style: AppTextStyle.h3.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black.withOpacity(0.8),
                                  fontSize: AppSize.s14,
                                ),
                              ),
                              AppSpacing(width: AppSize.s5),
                              Text(
                                "${expert.experienceYears} Year",
                                style: AppTextStyle.h3.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing(height: AppSize.s5),
                          Row(
                            children: [
                              Text(
                                "Total Sessions:",
                                style: AppTextStyle.h3.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black.withOpacity(0.8),
                                  fontSize: AppSize.s14,
                                ),
                              ),
                              AppSpacing(width: AppSize.s5),
                              Text(
                                (expert.totalReviews ?? 0).toString(),
                                style: AppTextStyle.h3.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing(height: AppSize.s5),
                          Row(
                            children: [
                              Text(
                                "Languages:",
                                style: AppTextStyle.h3.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black.withOpacity(0.8),
                                  fontSize: AppSize.s14,
                                ),
                              ),
                              AppSpacing(width: AppSize.s5),
                              Text(
                                expert.languagesSpoken ?? '',
                                style: AppTextStyle.h3.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing(height: AppSize.s5),
                          Row(
                            children: [
                              Text(
                                "Available On:",
                                style: AppTextStyle.h3.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black.withOpacity(0.8),
                                  fontSize: AppSize.s14,
                                ),
                              ),
                              AppSpacing(width: AppSize.s5),
                              Text(
                                expert.availabeOn ?? '',
                                style: AppTextStyle.h3.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing(height: AppSize.s10),
                        ],
                      ),
                    ),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: AppColor.primary,
                            unselectedLabelColor: AppColor.grey,
                            indicatorColor: AppColor.primary,
                            tabs: const [
                              Tab(text: 'Skill'),
                              Tab(text: 'Bio'),
                              Tab(text: 'Reviews'),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: AppSize.s15),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.screenSpacing,
                                    ),
                                    child: expert.skill == null || expert.skill!.isEmpty
                                        ? _buildNoData()
                                        : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  (expert.skill!.length / 2)
                                                      .ceil(), // number of rows
                                              itemBuilder: (context, rowIndex) {
                                                final firstSkill =
                                                    expert.skill![rowIndex * 2];
                                                final secondSkill =
                                                    (rowIndex * 2 + 1 <
                                                            expert.skill!.length)
                                                        ? expert.skill![rowIndex *
                                                                2 +
                                                            1]
                                                        : null;

                                                return Padding(
                                                  padding: const EdgeInsets.only(
                                                    bottom: AppSize.s20,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: _buildSkillTile(
                                                          firstSkill.skillName ??
                                                              '',
                                                        ),
                                                      ),
                                                      AppSpacing(
                                                        width: AppSize.s20,
                                                      ),
                                                      Expanded(
                                                        child:
                                                            secondSkill != null
                                                                ? _buildSkillTile(
                                                                  secondSkill
                                                                          .skillName ??
                                                                      '',
                                                                )
                                                                : const SizedBox(),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.screenSpacing,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildBulletPoint(expert.bio ?? ''),
                                      ],
                                    ),
                                  ),
                                  expert.review == null || expert.review!.isEmpty
                                      ? _buildNoData()
                                      : ListView.builder(
                                        itemCount: expert.review!.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          ReviewModel review = expert.review![index];
                                          return ReviewItem(review: review);
                                        },
                                      ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.s20,
                      ),
                      child: AppButton(
                        height: AppSize.s50,
                        onTap: () {
                          context.push(
                            AppRoutes.appointmentBooking,
                            extra: expert,
                          );
                        },
                        buttonText: "Book Appointment",
                      ),
                    ),
                  ],
                );
              } else if (state is ExpertFailure) {
                return Center(child: Text(state.message));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSize.s30),
        child: Text(
          "No Data Found!",
          style: AppTextStyle.h4,
        ),
      ),
    );
  }

  Widget _buildSkillTile(String skill) {
    return Container(
      padding: EdgeInsets.all(AppSize.s10),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          skill,
          style: AppTextStyle.h4.copyWith(fontSize: AppSize.s14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSize.s6),
          child: Icon(Icons.circle, size: AppSize.s10),
        ),
        AppSpacing(width: AppSize.s20),
        Expanded(child: Text(text, style: AppTextStyle.h5)),
      ],
    );
  }
}
