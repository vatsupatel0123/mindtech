import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mindtech/blocs/appointment/appointment_bloc.dart';
import 'package:mindtech/blocs/expert/expert_bloc.dart';
import 'package:mindtech/blocs/home/home_bloc.dart';
import 'package:provider/provider.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_theme.dart';
import 'package:mindtech/app/network/app_env.dart';
import 'package:mindtech/app/network/app_routing.dart';
import 'package:mindtech/app/utils/local_notification_helper.dart';
import 'package:mindtech/app/widgets/app_loader.dart';
import 'package:mindtech/blocs/auth/auth_bloc.dart';
import 'package:mindtech/providers/user_provider.dart';
import 'package:mindtech/screens/splash_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  try {
    await dotenv.load(fileName: Environment.fileName);
  } catch (e) {
    print(e);
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotificationHelper.initialize();
  FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message);
    if (!kIsWeb) {
      LocalNotificationHelper.showNotification(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  });

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(LocalNotificationHelper.showNotification);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: AppColor.transparent,
          statusBarIconBrightness: Brightness.dark
      ),
      child: GlobalLoaderOverlay(
        overlayWidgetBuilder: (_) {
          return AppLoader();
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserProvider()),
            BlocProvider(create: (_) => AuthBloc()),
            BlocProvider(create: (_) => HomeBloc()),
            BlocProvider(create: (_) => AppointmentBloc()),
            BlocProvider(create: (_) => ExpertBloc()),
          ],
          child: MaterialApp.router(
            title: AppString.appName,
            debugShowCheckedModeBanner: false,
            theme: getApplicationTheme(),
            routerConfig: appRouter,
          ),
        ),
      ),
    );
  }
}
