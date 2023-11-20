import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:get/get.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hourses/Home.dart';
import 'package:hourses/Login.dart';
import 'package:hourses/Setting.dart';
import 'package:hourses/helper/My_Button.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:hourses/helper/Praf_handler.dart';
import 'package:hourses/helper/my_helper.dart';
import 'package:hourses/model/Horse_model.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helper/notifi_service.dart';
import 'model/Shedule_model.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'dart:convert';
import 'dart:io' show Platform;


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

  final String applicationName= "Birthday Calendar";
const String channel_id = "123";

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final int _selectedIndex;
    await initializeService();
   init(_onDidReceiveLocalNotification);

  // NotificationService().initNotification();
  // tz.initializeTimeZones();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  final int _selectedIndex=0;

  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: Home(),
      
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
 Future<dynamic> _onDidReceiveLocalNotification(
      int id,
      String? title,
      String? body,
      String? payload) async {
  //  showDialog(
  //      context: context, 
    //    builder: (BuildContext context) =>
            AlertDialog(
                title: Text(title ?? ''),
                content: Text(body ?? ''),
                actions: [
                  TextButton(
                      child: Text("Ok"),
                      onPressed: () async {
//                        _notificationService.handleApplicationWasLaunchedFromNotification(payload ?? '');
                      }
                  )
                ]
           );
    //);
  }
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void init(Future<dynamic> Function(int, String?, String?, String?)? onDidReceive) {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceive);

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: null);
  print("find");
    initializeLocalNotificationsPlugin(initializationSettings);

    tz.initializeTimeZones();
  }

  void initializeLocalNotificationsPlugin(InitializationSettings initializationSettings) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    print("RRS");
///    handleApplicationWasLaunchedFromNotification("");
  }

  Future selectNotification(String? payload) async {
//    UserBirthday userBirthday = getUserBirthdayFromPayload(payload ?? '');
//    cancelNotificationForBirthday(userBirthday);
      print("===========mmmmmm=============");
  List<Shedule_modle> shedule_list=[];
        int hour_befor=await praf_handler.get_int(my_helper.hour_before);

        if(hour_befor==0)
          hour_befor=1;


        DateTime hour_before_time=DateTime.now();
        hour_before_time=hour_before_time.add(Duration(minutes: hour_befor));
        shedule_list=await praf_handler.get_shedule_list(my_helper.shedule+hour_before_time.millisecondsSinceEpoch.toString());
            print("fool");

        shedule_list.forEach((element) {
          if(element.alert_on){

            String b=DateFormat('dd/MM/yyyy HH:mm').format(hour_before_time);
            String c=DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(element.shedule_time));
           print('B: ${b}');
           print('B: ${c}');

//            if(b==c)
 //             send_noti(element.time, 'hour before alert');
        scheduleNotificationForBirthday(hour_before_time, " has an upcoming birthday!");

          }
        });
  }
  /*
  void handleApplicationWasLaunchedFromNotification(String payload) async {
    if (Platform.isIOS) {
      _rescheduleNotificationFromPayload(payload);
      return;
    }

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null && notificationAppLaunchDetails.didNotificationLaunchApp) {
      _rescheduleNotificationFromPayload(notificationAppLaunchDetails.payload ?? "");
    }
  }
  */
  /*
  void _rescheduleNotificationFromPayload(String payload) {
    UserBirthday userBirthday = getUserBirthdayFromPayload(payload);
    cancelNotificationForBirthday(userBirthday);
    scheduleNotificationForBirthday(userBirthday, "${userBirthday.name} has an upcoming birthday!");
  }
  */
  void showNotification(DateTime userBirthday, String notificationMessage) async {
    String formattedBirthday = userBirthday.toIso8601String(); // Convert DateTime to string
    await flutterLocalNotificationsPlugin.show(
      userBirthday.hashCode,
      applicationName,
      notificationMessage,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channel_id,
          "Birthday Calendar",
          channelDescription: 'To remind you about upcoming birthdays',
        ),
      ),
      payload: jsonEncode(formattedBirthday), // Encode the string representation
    );
  }

  void scheduleNotificationForBirthday(DateTime userBirthday, String notificationMessage) async {
    DateTime now = DateTime.now();
    DateTime birthdayDate = userBirthday;
    DateTime correctedBirthdayDate = birthdayDate;

    if (birthdayDate.year < now.year) {
      correctedBirthdayDate = new DateTime(now.year, birthdayDate.month, birthdayDate.day);
    }

    Duration difference = now.isAfter(correctedBirthdayDate)
        ? now.difference(correctedBirthdayDate)
        : correctedBirthdayDate.difference(now);

    bool didApplicationLaunchFromNotification = await _wasApplicationLaunchedFromNotification();
    if (!didApplicationLaunchFromNotification && difference.inDays == 0) {
      showNotification(userBirthday, notificationMessage);
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
        userBirthday.hashCode,
        applicationName,
        notificationMessage,
        tz.TZDateTime.now(tz.local).add(difference),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                channel_id,
                "Birthday Calendar",
                channelDescription: 'To remind you about upcoming birthdays')
        ),
        payload: jsonEncode(userBirthday),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future<bool> _wasApplicationLaunchedFromNotification() async {
    NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null) {
      return notificationAppLaunchDetails.didNotificationLaunchApp;
    }

    return false;
  }


Future<void> initializeService() async {
  final service = FlutterBackgroundService();


  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,
  ].request();


  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

   //if (Platform.isIOS || Platform.isAndroid) {
  //   await flutterLocalNotificationsPlugin.initialize(
  //     const InitializationSettings(
  //       iOS: DarwinInitializationSettings(),
  //       android: AndroidInitializationSettings('ic_bg_service_small'),
  //     ),
  //   );
  // }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      // onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

 /* AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
          channelGroupKey: 'mcg',
          channelKey: 'mc',
          channelName: 'bn',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],


  );
*/
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  hour_timer(service);
  day_timer(service);

}


hour_timer(var service)async{
  Timer.periodic(const Duration(minutes: 1), (timer) async {
  //    if (await service.isForegroundService()) {


        List<Shedule_modle> shedule_list=[];
        int hour_befor=await praf_handler.get_int(my_helper.hour_before);
       int day_befor=await praf_handler.get_int(my_helper.day_before);

        if(hour_befor==0)
          hour_befor=1;


        DateTime hour_before_time=DateTime.now();
        DateTime day_before_time=DateTime.now();

        hour_before_time=hour_before_time.add(Duration(minutes: hour_befor));
        day_before_time=hour_before_time.add(Duration(days: day_befor));

        shedule_list=await praf_handler.get_shedule_list(my_helper.shedule_total);
            print("fool");

        print(shedule_list);
        print(shedule_list.length);
        print("====1===");
        shedule_list.forEach((element) {
          print("element");
          print(element);
          if(element.alert_on){

            String b=DateFormat('dd/MM/yyyy HH:mm').format(hour_before_time);
            String d=DateFormat('dd/MM/yyyy HH:mm').format(day_before_time);
            String c=DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(element.shedule_time));
           print('B: ${b}');
           print('B: ${c}');

            if(b==c)
            {
               String message;
               message = "Appointment with " + element.owner_name;
               message += element.shedule_time.toString();
               showNotification(DateTime.now(), message);
            }
            if(d==c)
            {
               String message;
               message = "Appointment with " + element.owner_name;
               message += element.shedule_time.toString();
               showNotification(DateTime.now(), message);
            }

//              send_noti(element.time, 'hour before alert');
          }
        });




        int noti_duration=await praf_handler.get_int(my_helper.noti_duration);
         String e=DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(noti_duration));

        int noti_time=await praf_handler.get_int(my_helper.noti_time);
        String noti_msg=await praf_handler.get_string(my_helper.noti_txt);
            String c=DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

//        if(noti_duration>0){
//          if(noti_duration<DateTime.now().millisecondsSinceEpoch) { 
          if(e == c) { 

            List<Horse_model> horse_list=await praf_handler.get_horse_list(my_helper.all_horses);

            horse_list.forEach((element) async{

//              Telephony.instance.sendSms(to: element.owner_nbr, message: noti_msg);
            var message = "Your message goes here";
            var url = Uri.parse('sms:${element.owner_nbr}?body=$message');

              await launchUrl(url);

            });

            send_noti('alert', noti_msg);
            var dt=DateTime.now();
            dt=dt.add(Duration(days: noti_time));

            praf_handler.set_int(my_helper.noti_duration, dt.millisecondsSinceEpoch);

          }

     //   }



 
  //  }
    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

  });
}

day_timer(var service)async{
  Timer.periodic(const Duration(days: 1), (timer) async {
//    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {


        List<Shedule_modle> shedule_list=[];
        int day_befor=await praf_handler.get_int(my_helper.day_before);

        if(day_befor==0)
          day_befor=1;


        DateTime day_before_time=DateTime.now();
        day_before_time=day_before_time.add(Duration(days: day_befor));
        shedule_list=await praf_handler.get_shedule_list(my_helper.shedule_total);

        shedule_list.forEach((element) {
          if(element.alert_on){
            send_noti(element.time, 'day before alert');
          }
        });









      }
    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

  });
}

send_noti(String title,String msg){

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(10000),
        channelKey: 'mc',
        actionType: ActionType.Default,
        title: title,
        body:  msg,
      )
  );
}

 