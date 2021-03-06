import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifier {
  /// Instance of the local notifications builder
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Whether or not notifications should send right now
  bool _disabled = false;

  /// May need to be moved to a per-function basis
  NotificationDetails _platform;

  Notifier() {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    _plugin.initialize(initSettings);

    var androidDetails = AndroidNotificationDetails(
        'ghostapp', 'ghostapp', 'Ghost App',
        importance: Importance.Max, priority: Priority.High, playSound: false);
    var iosDetails = IOSNotificationDetails();

    _platform = NotificationDetails(androidDetails, iosDetails);
  }

  Future testNotification() async {
    if (_disabled) {
      return;
    }
    await _plugin.show(0, "Ghost is calling you!", null, _platform);
  }

  Future dayNotification() async {
    if (_disabled) {
      return;
    }
    await _plugin.show(
        0, "Day cycle is on", "You can regenerate your energy now!", _platform);
  }

  Future nightNotification() async {
    if (_disabled) {
      return;
    }
    await _plugin.show(0, "Night cycle is on",
        "You can interact with the ghost now!", _platform);
  }

  enable() {
    _disabled = false;
  }

  disable() {
    _disabled = true;
  }

  /*_hideNotification() async {
    await _plugin.cancel(0);
  }*/
}
