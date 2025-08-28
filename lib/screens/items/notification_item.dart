import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/utils/common_helper.dart';
import 'package:mindtech/models/notification_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if(notification.notificationUrl!=null){
          final url = Uri.parse(notification.notificationUrl ??'');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $url';
          }
        }

      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: AppSize.s10,vertical: AppSize.s7),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.notificationTitle ?? '', style: AppTextStyle.h3),
            Text(
              notification.notificationDesc ?? '',
              style: AppTextStyle.h5.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: AppColor.black,
              ),
            ),
            if (notification.notificationUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Click here to read more",
                  style: AppTextStyle.h5.copyWith(
                    color: AppColor.blue,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            SizedBox(height: AppSize.s3),
            Text(
              CommonHelper.formatNotificationTime(notification.notificationDate.toString()),
              style: AppTextStyle.h5.copyWith(
                fontSize: AppSize.s12,
                color: AppColor.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
