import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/home/home_bloc.dart';
import 'package:mindtech/blocs/home/home_event.dart';
import 'package:mindtech/blocs/home/home_state.dart';
import 'package:mindtech/providers/user_provider.dart';
import 'package:mindtech/screens/items/appbar_custom.dart';
import 'package:mindtech/screens/items/expert_item.dart';
import 'package:mindtech/screens/widgets/mood_icon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedMoodId;
  final TextEditingController moodNoteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback){
      final homebloc = context.read<HomeBloc>();
      homebloc.add(GetHomeData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SaveMoodLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  AppSpacing(height: AppSize.s20),
                  if(!state.profileIsComplete)Container(
                    width: double.infinity,
                    height: 150,
                    margin: EdgeInsets.symmetric(horizontal: AppSize.screenSpacing),
                    decoration: BoxDecoration(
                      color: Color(0xffffc1e8),
                      borderRadius: BorderRadius.circular(AppSize.s10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: AppSize.s7,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(AppImage.complete_profile_bg,width: 130,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: AppSize.s10,bottom: AppSize.s10,right: AppSize.s10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppString.complete_profile_title, style: AppTextStyle.h3),
                                Text(
                                  AppString.complete_profile_desc,
                                  style: AppTextStyle.h5.copyWith(fontSize: AppSize.s12),
                                ),
                                AppSpacing(height: AppSize.s15),
                                AppButton(
                                  onTap: () {
                                    context.push(AppRoutes.completeprofile);
                                  },
                                  buttonText: AppString.get_started,
                                  width: 130,
                                  height: AppSize.s40,
                                  buttonTextFontSize: AppSize.s14,
                                  buttonColor: AppColor.secondery,
                                  textColor: AppColor.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(!state.profileIsComplete)AppSpacing(height: AppSize.s20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.screenSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppString.our_experts, style: AppTextStyle.h3),
                        GestureDetector(
                          onTap: () {
                            this.context.push(AppRoutes.bottomNav,extra: 2);
                          },
                          child: Text(AppString.view_all, style: AppTextStyle.h4.copyWith(color: Colors.blue,fontWeight: FontWeight.w500)))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.experts.length,
                      padding: EdgeInsets.symmetric(horizontal: AppSize.screenSpacing),
                      itemBuilder: (context, index) {
                        return ExpertItem(
                          experts: state.experts[index],
                          width: 300,
                        );
                      },
                    ),
                  ),
                  AppSpacing(height: AppSize.s15,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: AppSize.screenSpacing),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSize.s10),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: AppSize.s8, offset: Offset(0,4))],
                    ),
                    child: state.moodSubmittedToday?Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: AppNetworkImage(
                            imageUrl: state.todayMood!.moodIcon ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(state.todayMood!.moodDesc ?? '', style: AppTextStyle.h5),
                        AppSpacing(height: AppSize.s15,),
                        AppButton(
                          onTap: () {
                            this.context.push(AppRoutes.bottomNav,extra: 2);
                          },
                          buttonText: state.todayMood!.moodButtonText ?? '',
                          width: double.infinity,
                          height: 40,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          buttonTextFontSize: 14,
                          buttonColor: HexColor.fromHex(state.todayMood!.moodButtonColor ?? ''),
                        ),
                        AppSpacing(height: AppSize.s5,),
                      ],
                    ):Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppString.save_mood_title, style: AppTextStyle.h3),
                        SizedBox(height: AppSize.s12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: state.moods.map((mood) {
                            final isSelected = mood.moodId == _selectedMoodId;
                            return MoodIcon(
                              emoji: mood.moodIcon ?? "🙂",
                              label: mood.moodName ?? "",
                              isSelected: isSelected,
                              onSelected: () {
                                setState(() {
                                  _selectedMoodId = mood.moodId;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Add a note (optional)",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          controller: moodNoteController,
                          maxLines: 2,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: AppSize.s10),
                        AppButton(
                          buttonText: AppString.save_mood,
                          onTap: (){
                            FocusScope.of(context).unfocus();
                            if (_selectedMoodId != null) {
                              context.read<HomeBloc>().add(
                                SaveMoodEvent(
                                  moodId: _selectedMoodId ?? 0,
                                  moodNote: moodNoteController.text,
                                ),
                              );
                            }else{
                              CommonHelper.flutterToast(context, "Please select mood any mood");
                            }
                          },
                          isLoading: state is SaveMoodLoading,
                        )
                      ],
                    ),
                  ),
                  AppSpacing(height: AppSize.s30,),
                ],
              ),
            );
          } else if (state is HomeFailure) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}


