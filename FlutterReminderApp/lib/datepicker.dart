import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});
  @override
  State<DatePicker> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  late DateTime dt;
  late TimeOfDay time;
  final _formKey = GlobalKey<FormState>();

  final FlutterLocalNotificationsPlugin fltrNotification =
      FlutterLocalNotificationsPlugin();

  List alarms = [];
  int counter = 0;
  List<Item> reminders = [];
  String? reminder;

  @override
  void initState() {
    super.initState();
    dt = DateTime.now();
    time = TimeOfDay.now();
    _initTimezone();
    _initNotification();
  }

  Future<void> _initTimezone() async {
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final tzName = tzInfo.identifier; // ✅ đúng field

      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (e) {
      print("Timezone error: $e");
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _initNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await fltrNotification.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (res) {
        _showDialog(res.payload);
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'Reminders',
      description: 'Reminder Notifications',
      importance: Importance.max,
    );

    await fltrNotification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _schedule(DateTime time, int id) async {
    final tzTime = tz.TZDateTime.from(time, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Reminders',
      channelDescription: 'Reminder Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await fltrNotification.zonedSchedule(
      counter,
      "Epap",
      alarms[id][4],
      tzTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: alarms[id][4],
    );

    setState(() {
      alarms[id][2] = tzTime;
      alarms[id][3] = counter;
      counter++;
    });
  }

  Future pickDate(BuildContext context, int? index) async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: index != null ? alarms[index][0] : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (d == null) return;
    setState(() => dt = d);
    pickTime(context, index);
  }

  Future pickTime(BuildContext context, int? index) async {
    TimeOfDay tod = TimeOfDay.now();
    TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: index != null
          ? alarms[index][1]
          : TimeOfDay(hour: tod.hour, minute: tod.minute + 1),
    );

    if (t == null) return;

    time = t;
    await _setReminder();

    if (reminder == null) return;

    DateTime schedule = dt.add(
      Duration(hours: t.hour, minutes: t.minute, seconds: 1),
    );

    if (schedule.isAfter(DateTime.now())) {
      int id = alarms.length;

      setState(() {
        alarms.add([dt, time, false, counter, reminder]);
        reminders = _genItems(alarms);
      });

      await _schedule(schedule, id);
      reminder = null;
    }
  }

  Future _setReminder() async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (v) => (v == "" ? "Enter reminder" : null),
                    onSaved: (input) => reminder = input,
                    decoration: InputDecoration(
                      labelText: 'Reminder',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(String? payload) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text("Reminder: $payload")),
    );
  }

  List<Item> _genItems(List a) {
    return List.generate(
      a.length,
      (i) => Item(
        id: a[i][3],
        headerValue: a[i][4],
        expandedValue:
            "${a[i][0].day}/${a[i][0].month}/${a[i][0].year} ${a[i][1].format(context)}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reminders")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pickDate(context, null),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        // ✅ tránh lỗi layout vô hạn
        child: ExpansionPanelList(
          expansionCallback: (i, open) =>
              setState(() => reminders[i].isExpanded = !open),
          children: reminders.map((e) {
            int i = reminders.indexOf(e);
            return ExpansionPanel(
              headerBuilder: (_, __) => ListTile(title: Text(e.headerValue)),
              body: ListTile(
                title: Text(e.expandedValue),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    fltrNotification.cancel(e.id);
                    setState(() {
                      alarms.removeAt(i);
                      reminders.removeAt(i);
                    });
                  },
                ),
              ),
              isExpanded: e.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Item {
  Item({
    required this.id,
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });

  int id;
  String headerValue;
  String expandedValue;
  bool isExpanded;
}
