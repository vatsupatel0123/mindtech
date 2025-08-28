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
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/expert/expert_bloc.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/expert/expert_state.dart';
import 'package:mindtech/models/appointment_model.dart';
import 'package:mindtech/screens/items/appbar_custom.dart';
import 'package:mindtech/screens/items/expert_appoinment_item.dart';
import 'package:mindtech/screens/items/expert_item.dart';

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({super.key});

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends State<ExpertHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback){
      final expertbloc = context.read<ExpertBloc>();
      expertbloc.add(GetExpertAppoinmentData(limit: '5'));
    });
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  AppSpacing(height: AppSize.s20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.screenSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppString.upcoming_session, style: AppTextStyle.h3),
                        Text(AppString.view_all, style: AppTextStyle.h4.copyWith(color: Colors.blue,fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: state.upcoming.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: AppSize.s10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      AppointmentModel appointment = state.upcoming[index];
                      return ExpertAppoinmentItem(appointment:appointment,status: 0,);
                    },
                  ),
                  AppSpacing(height: AppSize.s15,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.screenSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppString.past_session, style: AppTextStyle.h3),
                        Text(AppString.view_all, style: AppTextStyle.h4.copyWith(color: Colors.blue,fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: state.completed.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: AppSize.s10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      AppointmentModel appointment = state.completed[index];
                      return ExpertAppoinmentItem(appointment:appointment,status: 1,);
                    },
                  ),
                ],
              ),
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


