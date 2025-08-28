import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/config/appnetwork_image.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/app/network/app_url.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/screens/widgets/app_rating.dart';

class ExpertItem extends StatelessWidget {
  final ExpertModel experts;
  final double? width;

  const ExpertItem({
    required this.experts,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.expertsDetails,
          extra: experts,
        );
      },
      child: Container(
        width: width??double.infinity,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(right: width==null?0:15,bottom: 10,top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,3))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: AppNetworkImage(
                  imageUrl: experts.photo ?? '',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppSpacing(width: width==null?60:40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experts.expertName ?? '',
                    style: AppTextStyle.h3,
                  ),
                  Text(
                    experts.qualification ?? '',
                    style: AppTextStyle.h5.copyWith(fontSize: 13,overflow: TextOverflow.ellipsis),
                  ),
                  AppSpacing(height: 6),
                  AppRating(
                    rating: double.parse(experts.avgRating ?? '0'),
                    size: 16,
                    showValue: true,
                  ),
                  AppSpacing(height: 10,),
                  AppButton(
                    onTap: () {
                      context.push(
                        AppRoutes.appointmentBooking,
                        extra: experts,
                      );
                    },
                    buttonText: AppString.book_appointment,
                    width: 130,
                    height: 32,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    buttonTextFontSize: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
