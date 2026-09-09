import 'package:dosemate/bloc/reminder/reminder_bloc.dart';
import 'package:dosemate/bloc/reminder/reminder_state.dart';
import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';
import 'package:dosemate/db/user.dart';
import 'package:dosemate/models/dose_reminder.dart';
import 'package:dosemate/widgets/reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  bool _isTimeReached(TimeOfDay reminderTime, DateTime? snoozedUntil) {
    final now = DateTime.now();

    if (snoozedUntil != null) {
      return now.isAfter(snoozedUntil) || now.isAtSameMomentAs(snoozedUntil);
    }

    final doseDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    return now.isAfter(doseDateTime) || now.isAtSameMomentAs(doseDateTime);
  }

  bool _isDoseMissed(TimeOfDay reminderTime) {
    final now = DateTime.now();
    final doseDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      reminderTime.hour,
      reminderTime.minute,
    );
    final twoHoursAfter = doseDateTime.add(const Duration(hours: 2));

    return now.isAfter(twoHoursAfter);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReminderBloc, ReminderState>(
  listenWhen: (previous, current) {
    return current is ReminderUpdateSuccess && previous != current;
  },
  listener: (context, state) {
    if (state is ReminderUpdateSuccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message, style: AppStyles.body),
          backgroundColor: ConstantColors.secondary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  },
      child: Scaffold(
        backgroundColor: ConstantColors.tertiaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'جرعتي',
            style: AppStyles.pageTitle.copyWith(color: ConstantColors.primaryColor),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ReminderBloc, ReminderState>(
                  builder: (context, state) {
                    final userReminders = state.reminders.where((reminder)=>reminder.userId==currentUser!.id).toList();
                    int completedCount =
                        userReminders.where((item) => item.status == 'taken').length;
                    double progress =
                        userReminders.isEmpty ? 0 : completedCount / userReminders.length;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ConstantColors.primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'التزام اليوم',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'أنجزت $completedCount من أصل ${userReminders.length} جرعات',
                            style: AppStyles.subtitle.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              ConstantColors.tertiaryColor,
                            ),
                            minHeight: 8,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'جدول أدوية اليوم',
                  style: AppStyles.subtitle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: BlocBuilder<ReminderBloc, ReminderState>(
                    builder: (context, state) {
                      final userReminders = state.reminders.where((reminder)=>reminder.userId==currentUser!.id).toList();

                      if (userReminders.isEmpty) {
                        return Center(
                          child: Text(
                            'لا توجد جرعات مضافة لليوم',
                            style: AppStyles.body.copyWith(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: userReminders.length,
                        itemBuilder: (context, index) {
                          final reminder =userReminders[index];
                          return ReminderCard(
                            reminder: reminder,
                            timeReached: _isTimeReached(
                              reminder.reminderTime,
                              reminder.snoonzedUntil,
                            ),
                            isMissed: _isDoseMissed(reminder.reminderTime),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}