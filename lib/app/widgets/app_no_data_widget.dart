import 'package:flutter/material.dart';
import 'package:mindtech/app/config/app_text_styles.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height*0.70,
        alignment: Alignment.center,
        child: Text(
          "No Data Found",
          style: AppTextStyle.h2,
        ),
      ),
    );
  }
}
