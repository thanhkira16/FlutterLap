import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as t;
import 'package:flutter_timezone/flutter_timezone.dart';

class TimeZone {
  factory TimeZone() => _this ??= TimeZone._();

  TimeZone._() {
    initializeTimeZones();
  }

  static TimeZone? _this;

  /// Trả về chuỗi IANA timezone, ví dụ "Asia/Bangkok"
  Future<String> getTimeZoneName() async {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    return timezoneInfo.identifier; // <-- lấy identifier (String)
  }

  Future<t.Location> getLocation([String? timeZoneName]) async {
    if (timeZoneName == null || timeZoneName.isEmpty) {
      timeZoneName = await getTimeZoneName();
    }
    return t.getLocation(timeZoneName);
  }
}
