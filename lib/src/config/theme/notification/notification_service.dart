import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class LocalNotificationService{
  
  //* instance
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  //* init-setting
    Future<void> setup()async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSetting = InitializationSettings(android: androidSetting,iOS: DarwinInitializationSettings());
    await _localNotificationsPlugin.initialize(initSetting)
      .then((_) => dev.log('Setup Notificaton'))
      .catchError((e)=> dev.log('Failed Notification'));
  }

    addNotification(String title,String body,String channel,)async{
      tzData.initializeTimeZones();
      final scheduleTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, DateTime.now().millisecondsSinceEpoch + 1000);

      final androidDetails = AndroidNotificationDetails(
        channel, channel,
        importance: Importance.max,
        priority: Priority.high,
        );
      const iosDetail = DarwinNotificationDetails();
      final notifDetail = NotificationDetails( android: androidDetails, iOS: iosDetail );

      int id = Random().nextInt(10);

      await _localNotificationsPlugin.zonedSchedule(
        id, 
        title, 
        body,   
        scheduleTime, 
        notifDetail, 
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    }
    
    void cancleAllNotification()=>_localNotificationsPlugin.cancelAll();

}

