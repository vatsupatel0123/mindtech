import 'package:flutter/material.dart';

class AppSpacing extends StatelessWidget {
  final double? height;
  final double? width;

  const AppSpacing({
    this.height,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: height != null ? size.height * (height! / 1000) : null,
      width: width != null ? size.width * (width! / 1000) : null,
    );
  }
}