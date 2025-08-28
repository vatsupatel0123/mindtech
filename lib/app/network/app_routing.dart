import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindtech/app/network/app_routes.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/screens/appointment_booking_screen.dart';
import 'package:mindtech/screens/bottom_nav.dart';
import 'package:mindtech/screens/change_password.dart';
import 'package:mindtech/screens/completeprofile_screen.dart';
import 'package:mindtech/screens/editprofile_screen.dart';
import 'package:mindtech/screens/emergancy_screen.dart';
import 'package:mindtech/screens/expert_bottom_nav.dart';
import 'package:mindtech/screens/expert_home_screen.dart';
import 'package:mindtech/screens/experts_details_screen.dart';
import 'package:mindtech/screens/forgotemail_screen.dart';
import 'package:mindtech/screens/home_screen.dart';
import 'package:mindtech/screens/login_screen.dart';
import 'package:mindtech/screens/notification_screen.dart';
import 'package:mindtech/screens/otp_screen.dart';
import 'package:mindtech/screens/privacy_policy.dart';
import 'package:mindtech/screens/register_screen.dart' show RegisterScreen;
import 'package:mindtech/screens/splash_screen.dart';
import 'package:mindtech/screens/termsandconditions.dart';
import 'package:mindtech/screens/updatepassword_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) {
        final user = state.extra as UserCredential?;
        return RegisterScreen(
          isGoogle: user != null,
          user: user,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotemail,
      builder: (context, state) => ForgotEmailScreen(),
    ),
    GoRoute(
      path: AppRoutes.updatePassword,
      builder: (context, state) {
        final userId = state.extra as int?;
        return UpdatePasswordScreen(userId: userId??0);
      },
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      builder: (context, state) => ChangePasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        final userId = data['userId'] as int? ?? 0;
        final isForgotScreen = data['isForgotScreen'] as bool? ?? false;

        return OtpScreen(userId: userId, isForgotScreen: isForgotScreen);
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.bottomNav,
      builder: (context, state) {
        print(state.extra);
        final index = state.extra is int ? state.extra as int : 0;
        return BottomNav(index: index);
      },
    ),
    GoRoute(
      path: AppRoutes.expertBottomNav,
      builder: (context, state) => ExpertBottomNav(),
    ),
    GoRoute(
      path: AppRoutes.notification,
      builder: (context, state) => NotificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.emergency,
      builder: (context, state) => EmergencyScreen(),
    ),
    GoRoute(
      path: AppRoutes.completeprofile,
      builder: (context, state) => CompleteProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.expertsDetails,
      builder: (context, state) {
        final experts = state.extra as ExpertModel;
        return ExpertsDetailsScreen(experts: experts);
      },
    ),
    GoRoute(
      path: AppRoutes.appointmentBooking,
      builder: (context, state) {
        final experts = state.extra as ExpertModel;
        return AppointmentBookingScreen(experts: experts);
      },
    ),
    GoRoute(
      path: AppRoutes.expertHome,
      builder: (context, state) => ExpertHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      builder: (context, state) => PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: AppRoutes.termsAndConditions,
      builder: (context, state) => TermsAndConditionsScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => EditProfileScreen(),
    ),
  ],
);


