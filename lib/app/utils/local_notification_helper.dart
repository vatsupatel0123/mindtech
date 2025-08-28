import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as p;
import 'package:http/http.dart' as http;

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int? id;
  final String? title;
  final String? body;
  final String? payload;
}

@pragma('vm:entry-point')
class LocalNotificationHelper {
  //Instances
  static final flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  String selectedNotificationPayload = '';

  static final StreamController<String?> selectNotificationStream =
  StreamController<String?>.broadcast();

  //Methods
  @pragma('vm:entry-point')
  static initialize() async {
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureSelectNotificationSubject();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('launcher_icon');
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) async{  }

  static Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;
    }
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  @pragma('vm:entry-point')
  static Future showNotification(RemoteMessage message) async {
    await Firebase.initializeApp();
    if(message.data["is_play_alarm"]=="true"){
      if (message.data["image"] != null) {
        final String largeIconPath =
        await _downloadAndSaveFile(message.data["image"], 'largeIcon');
        final String bigPicturePath =
        await _downloadAndSaveFile(message.data["image"], 'bigPicture');
        final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            hideExpandedLargeIcon: true,
            contentTitle: message.data["title"],
            htmlFormatContentTitle: true,
            summaryText: message.data["body"],
            htmlFormatSummaryText: true);
        final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'Buddy',
          'Buddy',
          channelDescription: 'Buddy description',
          importance: Importance.high,
          priority: Priority.high,
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          styleInformation: bigPictureStyleInformation,
        );
        final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(DateTime.now().millisecond,
            message.data["title"], message.data["body"], notificationDetails);
      }
      else {
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'Buddy',
          'Buddy',
          channelDescription: 'Buddy notification',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'id_1',
              'Stop',
              showsUserInterface: true,
            ),
          ],
        );
        const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();
        const NotificationDetails platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iosNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
            DateTime.now().millisecond,
            message.data["title"],
            message.data["body"],
            platformChannelSpecifics,
            payload: "buddy"
        );
      }
      String timeString = message.data['time'];
      DateTime sentTimeUtc = DateTime.parse(timeString);
      DateTime sentTimeLocal = sentTimeUtc.toLocal();
      DateTime currentTimeLocal = DateTime.now();

      Duration difference = currentTimeLocal.difference(sentTimeLocal);
    }
    else{
      print(message.data["image"]);
      if (message.data["image"] != null && message.data["image"] != '') {
        final String largeIconPath =
        await _downloadAndSaveFile(message.data["image"], 'largeIcon');
        final String bigPicturePath =
        await _downloadAndSaveFile(message.data["image"], 'bigPicture');
        final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            hideExpandedLargeIcon: true,
            contentTitle: message.data["title"],
            htmlFormatContentTitle: true,
            summaryText: message.data["body"],
            htmlFormatSummaryText: true);
        final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'Buddy',
          'Buddy',
          channelDescription: 'Buddy description',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'launcher_icon',
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          styleInformation: bigPictureStyleInformation,
        );
        final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(DateTime.now().millisecond,
            message.data["title"], message.data["body"], notificationDetails);
      }
      else {
        AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'Buddy',
          'Buddy',
          channelDescription: 'Buddy notification',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'launcher_icon',
          styleInformation: BigTextStyleInformation(
            message.data["body"],
            htmlFormatBigText: true,
            contentTitle: message.data["title"],
          ),
        );
        const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();
        NotificationDetails platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iosNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecond,
          message.data["title"],
          message.data["body"],
          platformChannelSpecifics,
          payload: "buddy",
        );
      }
    }
  }

  static _downloadAndSaveFile(String url, String fileName) async {
    final p.Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      print("pay load");
      print(payload);
    });
  }

  static void onSelectNotification(payload) async {
    var data = json.decode(payload);
    print(data);
  }

  static cancelNotififcationWithID(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static cancelAllNotififcation() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
