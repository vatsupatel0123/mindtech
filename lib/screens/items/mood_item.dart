import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/config/appnetwork_image.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/models/mood_model.dart';

class MoodItem extends StatelessWidget {
  final MoodModel mood;

  const MoodItem({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          AppNetworkImage(imageUrl: mood.moodIcon ?? '', height: 50, width: 50),
          AppSpacing(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mood.moodName ?? '', style: AppTextStyle.h3),
                Text("Date: ${mood.addedDatetime!.toLocalDateTime()}", style: AppTextStyle.h5),
                // AppSpacing(height: AppSize.s10),
                // AppButton(
                //   onTap: () {
                //     // handle booking
                //   },
                //   buttonText: mood.moodButtonText ?? '',
                //   width: double.infinity,
                //   height: 40,
                //   padding: EdgeInsets.zero,
                //   margin: EdgeInsets.zero,
                //   buttonTextFontSize: 14,
                //   buttonColor: HexColor.fromHex(mood.moodButtonColor ?? ''),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
