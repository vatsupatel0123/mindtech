import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_images.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width, height;
  final BoxFit? fit;

  const AppCachedImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      errorWidget: (context, icon, error) {
        return Image.asset(
          AppImage.noImageAvalible,
          fit: BoxFit.cover,
        );
      },
      width: width,
      height: height,
      fit: fit ?? BoxFit.fill,
      progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Container(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
        ),
      ),
    );
  }
}
