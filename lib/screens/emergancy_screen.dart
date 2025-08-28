import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_specing.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/app/widgets/app_button.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/home/home_bloc.dart';
import 'package:mindtech/blocs/home/home_event.dart';
import 'package:mindtech/blocs/home/home_state.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      final bloc = context.read<HomeBloc>();
      bloc.add(GetSupportDetails());
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
          title: Text(
            "Emergency Support",
            style: AppTextStyle.h2.copyWith(color: AppColor.black),
          ),
          iconTheme: IconThemeData(color: AppColor.black),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.s10),
          child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is SupportDetailsLoading) {
                  return Center(child: CircularProgressIndicator());
                }else if (state is SupportDetailsLoaded){
                  final contactNo = state.contact_no;
                  final contactEmail = state.contact_email;

                  Future<void> _launchCaller(String number) async {
                    final Uri url = Uri(scheme: 'tel', path: number);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }

                  Future<void> _launchEmail(String email) async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: email,
                      query: Uri.encodeFull('subject=Support Request&body=Hello,'),
                    );

                    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
                      throw 'Could not launch $emailUri';
                    }
                  }
                  return Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Image.asset(AppImage.emergencyBG, height: 250),
                        ),
                      ),
                      // Heading text
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSize.s40),
                          child: Center(
                            child: Text(
                              "How can we\nhelp you?",
                              style: AppTextStyle.h1.copyWith(color: AppColor.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      // Buttons Row
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSize.s20),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _launchCaller(contactNo),
                                  child: Container(
                                    height: AppSize.s50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(AppSize.s5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AppImage.ic_call,width: AppSize.s25,),
                                        AppSpacing(width: AppSize.s20),
                                        Text(
                                          "Call Now",
                                          style: AppTextStyle.h2.copyWith(color: AppColor.black,fontSize: AppSize.s17),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AppSpacing(width: AppSize.s40),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _launchEmail(contactEmail),
                                  child: Container(
                                    height: AppSize.s50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.black),
                                      borderRadius: BorderRadius.circular(AppSize.s5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AppImage.ic_gmail,width: AppSize.s25,),
                                        AppSpacing(width: AppSize.s20),
                                        Text(
                                          "Email Help",
                                          style: AppTextStyle.h2.copyWith(color: AppColor.black,fontSize: AppSize.s17),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Bottom note
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSize.s40),
                          child: Center(
                            child: Text(
                              "In case of serious threat, contact local authorities",
                              style: AppTextStyle.h2.copyWith(color: AppColor.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container()
                      ),
                    ],
                  );
                } else if (state is SupportDetailsFailure) {
                  return Center(child: Text(state.message));
                }
                return Container();
            }
          ),
        ),
      ),
    );
  }
}
