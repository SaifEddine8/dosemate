// import 'package:dosemate/models/dose_reminder.dart';
// import 'package:flutter/material.dart';

// List<DoseReminder> reminders = [
//   DoseReminder(
//     name: 'بنادول أفانس',
//     medicationId: 101,
//     reminderTime: const TimeOfDay(hour: 8, minute: 0),
//     frequency: 'يومياً',
//     startDate: DateTime.now(),
//     endDate: DateTime.now().add(const Duration(days: 7)),
//     isActive: true,
//     dosageAmount: 1.0,
//     status: 'taken',
//   ),
//   DoseReminder(
//     name: 'أوميبرازول',
//     medicationId: 102,
//     reminderTime: const TimeOfDay(hour: 14, minute: 30),
//     frequency: 'يومياً',
//     startDate: DateTime.now(),
//     endDate: null, // دواء مستمر (مزمن)
//     isActive: true,
//     dosageAmount: 1.0,
//     status: 'missed',
//   ),
//   DoseReminder(
//     name: 'فيتامين C',
//     medicationId: 103,
//     reminderTime: const TimeOfDay(hour: 20, minute: 0),
//     frequency: 'يومياً',
//     startDate: DateTime.now(),
//     endDate: DateTime.now().add(const Duration(days: 30)),
//     isActive: true,
//     dosageAmount: 2.0,
//     status: 'pending',
//   ),
//   DoseReminder(
//     name: 'أمبرازول (مؤجل)',
//     medicationId: 102,
//     reminderTime: const TimeOfDay(hour: 22, minute: 0),
//     frequency: 'حسب الحاجة',
//     startDate: DateTime.now(),
//     isActive: false,
//     dosageAmount: 1.0,
//     status: 'snoozed',
//     snoonzedUntil: DateTime.now().add(const Duration(minutes: 15)),
//   ),
// ];