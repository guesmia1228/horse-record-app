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

import 'helper/notifi_service.dart';
import 'model/Shedule_model.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final int _selectedIndex;

  // await Firebase.initializeApp();
  //  await initializeService();
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

  // if (Platform.isIOS || Platform.isAndroid) {
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

  AwesomeNotifications().initialize(
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
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {


        List<Shedule_modle> shedule_list=[];
        int hour_befor=await praf_handler.get_int(my_helper.hour_before);

        if(hour_befor==0)
          hour_befor=1;


        DateTime hour_before_time=DateTime.now();
        hour_before_time=hour_before_time.add(Duration(hours: hour_befor));
        shedule_list=await praf_handler.get_shedule_list(my_helper.shedule+hour_before_time.millisecondsSinceEpoch.toString());

        shedule_list.forEach((element) {
          if(element.alert_on){

            String b=DateFormat('dd/MM/yyyy HH:mm').format(hour_before_time);
            String c=DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(element.shedule_time));
            if(b==c)
            send_noti(element.time, 'hour before alert');
          }
        });




        int noti_duration=await praf_handler.get_int(my_helper.noti_duration);
        int noti_time=await praf_handler.get_int(my_helper.noti_time);
        String noti_msg=await praf_handler.get_string(my_helper.noti_txt);

        if(noti_duration>0){
          if(noti_duration<DateTime.now().millisecondsSinceEpoch){

            List<Horse_model> horse_list=await praf_handler.get_horse_list(my_helper.all_horses);

            horse_list.forEach((element) {

              Telephony.instance.sendSms(to: element.owner_nbr, message: noti_msg);

            });

            send_noti('alert', noti_msg);
            var dt=DateTime.now();
            dt=dt.add(Duration(days: noti_time));

            praf_handler.set_int(my_helper.noti_duration, dt.millisecondsSinceEpoch);

          }

        }



      }
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

  });
}

day_timer(var service)async{
  Timer.periodic(const Duration(days: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {


        List<Shedule_modle> shedule_list=[];
        int day_befor=await praf_handler.get_int(my_helper.day_before);

        if(day_befor==0)
          day_befor=1;


        DateTime day_before_time=DateTime.now();
        day_before_time=day_before_time.add(Duration(days: day_befor));
        shedule_list=await praf_handler.get_shedule_list(my_helper.shedule+day_before_time.millisecondsSinceEpoch.toString());

        shedule_list.forEach((element) {
          if(element.alert_on){
            send_noti(element.time, 'day before alert');
          }
        });









      }
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
