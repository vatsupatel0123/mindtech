import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/appointment/appointment_bloc.dart';
import 'package:mindtech/blocs/appointment/appointment_event.dart';
import 'package:mindtech/blocs/appointment/appointment_state.dart';
import 'package:mindtech/blocs/home/home_bloc.dart';
import 'package:mindtech/blocs/home/home_event.dart';
import 'package:mindtech/blocs/home/home_state.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/models/mood_model.dart';
import 'package:mindtech/screens/items/appbar_custom.dart';
import 'package:mindtech/screens/items/appointment_item.dart';
import 'package:mindtech/screens/items/mood_item.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((call){
      final bloc = context.read<AppointmentBloc>();
      bloc.add(GetAppointmentData());
      final homebloc = context.read<HomeBloc>();
      homebloc.add(GetMoodData());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Column(
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.only(left:AppSize.screenSpacing,right: AppSize.screenSpacing,top: AppSize.s15,bottom: AppSize.s5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s5),
              color: AppColor.secondery,
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(AppSize.s5),
              ),
              unselectedLabelColor: AppColor.primary,
              labelColor: AppColor.white,
              labelStyle: AppTextStyle.h3,
              indicatorColor: AppColor.transparent,
              indicatorPadding: EdgeInsets.zero,
              dividerColor: AppColor.transparent,
              tabs: [
                Tab(child: Text("Session")),
                Tab(child: Text("Mood Journey")),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BlocBuilder<AppointmentBloc, AppointmentState>(
                    builder: (context, state) {
                      if (state is AppointmentLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is AppointmentLoaded) {
                        return ListView.builder(
                          itemCount: state.appointments.length,
                          padding: EdgeInsets.only(left: AppSize.screenSpacing,right: AppSize.screenSpacing,top: AppSize.s10),
                          itemBuilder: (context, index) {
                            AppointmentModel appointment = state.appointments[index];
                            return AppointmentItem(appointment: appointment);
                          },
                        );
                      } else if (state is AppointmentFailure) {
                        return Center(child: Text(state.message));
                      }
                      return Container();
                  }
                ),
                BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is MoodLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is MoodLoaded) {
                        return ListView.builder(
                          itemCount: state.moods.length,
                          padding: EdgeInsets.only(left: AppSize.screenSpacing,right: AppSize.screenSpacing,top: AppSize.s10),
                          itemBuilder: (context, index) {
                            MoodModel mood = state.moods[index];
                            return MoodItem(mood: mood);
                          },
                        );
                      } else if (state is HomeFailure) {
                        return Center(child: Text(state.message));
                      }
                      return Container();
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
