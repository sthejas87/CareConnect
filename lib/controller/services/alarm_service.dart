// ignore_for_file: avoid_print


import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> periodicAlarms(String tabName, TimeOfDay time, int paramId) async {
  const nbDays = 7; // Number of following days to potentially set alarm
  // Days of the week to set the alarm
  int count = 0;
  final now = DateTime.now();

  // Loop through the next days
  for (var i = 0; i < nbDays; i++) {
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).add(Duration(days: i));
    int id = int.parse("${paramId + 1}${dateTime.day}");
    if (kDebugMode) {
      print(id);
    }
    print(time);
    print(tabName);
    if (dateTime.isAfter(DateTime.now())) {
      final alarmSettings = AlarmSettings(
        androidFullScreenIntent: false,
        enableNotificationOnKill: false,
        loopAudio: false,
        id: id,
        dateTime: dateTime,
        vibrate: true,
        assetAudioPath: 'assets/alrm.wav',
        notificationTitle: 'Its Time To take $tabName',
        notificationBody: 'Medication Time.',
      );

      try {
        await Alarm.set(
          alarmSettings: alarmSettings,
        ).then(
          (value) {
            if (count == 0) {
              Get.showSnackbar(GetSnackBar(
                duration: const Duration(seconds: 5),
                title: "Alarm set at ",
                message: "${alarmSettings.dateTime}:: $value",
              ));
              count++;
            }
          },
        ).catchError((oneror) {
          if (count == 0) {
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 5),
              title: "alarm Errorr ",
              message: oneror.toString(),
            ));
            count++;
          }
        });
      } catch (e) {
        if (count == 0) {
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 5),
            title: "alarm Errorr ",
            message: e.toString(),
          ));
          count++;
        }
      }
    }
  }
}

Future<void> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  print('Schedule exact alarm permission: $status.');
  if (status.isDenied) {
    print('Requesting schedule exact alarm permission...');
    final res = await Permission.scheduleExactAlarm.request();
    print(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
  }
}

TimeOfDay parseTimeOfDay(String time) {
  // Check if the time string contains "AM" or "PM"
  final is12HourFormat =
      time.toLowerCase().contains('am') || time.toLowerCase().contains('pm');

  if (is12HourFormat) {
    // 12-hour format
    final parts = time.split(' ');
    final timePart = parts[0];
    final periodPart = parts[1].toLowerCase();

    final timeParts = timePart.split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    if (periodPart == 'pm' && hour != 12) {
      hour += 12;
    } else if (periodPart == 'am' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  } else {
    // 24-hour format
    final timeParts = time.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }
}
