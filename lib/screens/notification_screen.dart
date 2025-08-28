import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/blocs/home/home_bloc.dart';
import 'package:mindtech/blocs/home/home_event.dart';
import 'package:mindtech/blocs/home/home_state.dart';
import 'package:mindtech/models/notification_model.dart';
import 'package:mindtech/screens/items/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      final bloc = context.read<HomeBloc>();
      bloc.add(GetNotificationData());
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<HomeBloc>().add(GetHomeData());
        context.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          title: Text("Notification",style: AppTextStyle.h2.copyWith(color: AppColor.black),),
          iconTheme: IconThemeData(
            color: AppColor.black
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is NotificationLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is NotificationLoaded) {
                return ListView.builder(
                  itemCount: state.notifications.length,
                  padding: EdgeInsets.only(left: AppSize.screenSpacing,right: AppSize.screenSpacing,top: AppSize.s5),
                  itemBuilder: (context, index) {
                    NotificationModel notification = state.notifications[index];
                    return NotificationItem(notification: notification);
                  },
                );
              } else if (state is HomeFailure) {
                return Center(child: Text(state.message));
              }
              return Container();
            }
        ),
      ),
    );
  }
}
