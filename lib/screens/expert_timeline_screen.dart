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
import 'package:mindtech/blocs/expert/expert_bloc.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/expert/expert_state.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/screens/items/appbar_custom.dart';
import 'package:mindtech/screens/items/expert_appoinment_item.dart';

class ExpertTimelineScreen extends StatefulWidget {
  const ExpertTimelineScreen({super.key});

  @override
  State<ExpertTimelineScreen> createState() => _ExpertTimelineScreenState();
}

class _ExpertTimelineScreenState extends State<ExpertTimelineScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((callback){
      final expertbloc = context.read<ExpertBloc>();
      expertbloc.add(GetExpertAppoinmentData(limit: ''));
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
      body: BlocBuilder<ExpertBloc, ExpertState>(
        builder: (context, state) {
          if (state is GetExpertAppointmentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GetExpertAppointmentLoaded) {
            return Column(
              children: [
                Container(
                  height: 50,
                  margin: EdgeInsets.all(AppSize.screenSpacing),
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
                      Tab(child: Text("Upcoming")),
                      Tab(child: Text("Completed")),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                        itemCount: state.upcoming.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: AppSize.s2),
                        itemBuilder: (context, index) {
                          AppointmentModel appointment = state.upcoming[index];
                          return ExpertAppoinmentItem(appointment:appointment,status: 0,);
                        },
                      ),
                      ListView.builder(
                        itemCount: state.completed.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: AppSize.s2),
                        itemBuilder: (context, index) {
                          AppointmentModel appointment = state.completed[index];
                          return ExpertAppoinmentItem(appointment:appointment,status: 1,);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is GetExpertAppointmentFailure) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
