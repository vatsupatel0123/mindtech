import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/config/appnetwork_image.dart';

class MoodIcon extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onSelected;
  final bool isSelected;
  const MoodIcon({
    required this.emoji,
    required this.label,
    required this.onSelected,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 35,
            width: 50,
            alignment: Alignment.center,
            child: AppNetworkImage(
              imageUrl: emoji ?? '',
              width: isSelected ? 35 : 25,
              height: isSelected ? 35 : 25,
              fit: BoxFit.contain,  // better for icons, prevents cropping
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: AppTextStyle.h3),
        ],
      ),
    );
  }
}