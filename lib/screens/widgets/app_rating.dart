import 'package:flutter/material.dart';

class AppRating extends StatelessWidget {
  final double rating; // e.g. 4.3
  final double size;
  final Color color;
  final bool showValue;

  const AppRating({
    Key? key,
    required this.rating,
    this.size = 16,
    this.color = Colors.amber,
    this.showValue = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor(); // full stars
    bool hasHalfStar = (rating - fullStars) >= 0.5; // half star
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Full stars
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: color, size: size),

        // Half star
        if (hasHalfStar)
          Icon(Icons.star_half, color: color, size: size),

        // Empty stars
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: color, size: size),

        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(fontSize: size - 2),
          ),
        ]
      ],
    );
  }
}