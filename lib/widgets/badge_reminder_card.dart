import 'package:flutter/material.dart';

class BadgeReminderCard extends StatelessWidget {
  String status;
  bool timeReached;
   BadgeReminderCard({super.key, required this.status, required this.timeReached});

  @override
  Widget build(BuildContext context) {
     if (status == 'taken') return const Chip(label: Text('تمت'));
    if (status == 'snoozed') return const Chip(label: Text('مُتخطاة'));
    if (status == 'missed') return const Chip(label: Text('فُوتت'));
    if (!timeReached) return const Chip(label: Text('قادمة'));
    return const Chip(label: Text('حانت الآن!'));
  }
}