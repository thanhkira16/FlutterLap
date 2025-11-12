import 'package:flutter/material.dart';
import 'package:flutter_reminder_app/datepicker.dart';

class Epap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // ✅ bổ sung safe area
        child: DatePicker(), // ✅ bỏ Center
      ),
    );
  }
}
