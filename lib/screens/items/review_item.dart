import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/utils/extensions.dart';
import 'package:mindtech/models/review_model.dart';
import 'package:mindtech/screens/widgets/app_rating.dart';

class ReviewItem extends StatelessWidget {
  final ReviewModel review;
  const ReviewItem({super.key,required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSize.s15,
        right: AppSize.s15,
        bottom: AppSize.s10,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppRating(rating: double.parse(review.rating ?? '0')),
              const SizedBox(height: 5),
              Text(
                review.review ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                (review.adeddDate ?? '').toLocalDate(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
