import 'package:dosemate/bloc/reminder/reminder_bloc.dart';
import 'package:dosemate/bloc/reminder/reminder_event.dart';
import 'package:dosemate/bloc/reminder/reminder_state.dart';
import 'package:dosemate/core/constant/constant_colors.dart';
import 'package:dosemate/db/user.dart';
import 'package:dosemate/models/dose_reminder.dart';
import 'package:dosemate/widgets/badge_reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderCard extends StatelessWidget {
  final DoseReminder reminder;
  final bool timeReached;
  final bool isMissed;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.timeReached,
    required this.isMissed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderBloc, ReminderState>(
      builder: (context, state) {
        final index = state.reminders.indexWhere((r) => r.id == reminder.id&&r.userId==reminder.userId);
        final DoseReminder currentReminder =
            index != -1 ? state.reminders[index] : reminder;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medication_rounded,
                      color: currentReminder.status == 'taken'
                          ? ConstantColors.secondary
                          : ConstantColors.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentReminder.medicationId.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.primaryColor,
                            ),
                          ),
                          currentReminder.status == 'snoozed' && currentReminder.snoonzedUntil != null
                              ? Text(
                                  'الجرعة: ${currentReminder.dosageAmount} • الموعد: ${currentReminder.snoonzedUntil!.hour}:${currentReminder.snoonzedUntil!.minute}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                )
                              : Text(
                                  'الجرعة: ${currentReminder.dosageAmount} • الموعد: ${currentReminder.reminderTime.format(context)}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    BadgeReminderCard(
                      status: currentReminder.status,
                      timeReached: timeReached,
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (currentReminder.status == 'taken')
                  const Text(
                    'تم أخذ الجرعة بنجاح',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else if (currentReminder.status == 'snoozed')
                  const Text(
                    'تم تأجيل هذه الجرعة',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else if (currentReminder.status == 'missed')
                  const Text(
                    'فُوتت الجرعة (انتهى الموعد)',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else if (!timeReached)
                  const Row(
                    children: [
                      Icon(Icons.lock_clock, size: 16, color: Colors.grey),
                      SizedBox(width: 6),
                      Text(
                        'تتاح الخيارات عند حلول موعد الجرعة',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: .spaceAround,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantColors.secondary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          context.read<ReminderBloc>().add(
                                UpdateTakeReminder(currentReminder.id),
                              );
                        },
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('أخذت'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.read<ReminderBloc>().add(
                                UpdateSnoozeReminder(
                                  currentReminder.id,
                                  DateTime.now().add(
                                    const Duration(minutes: 15),
                                  ),
                                ),
                              );
                        },
                        icon: const Icon(Icons.snooze, size: 18),
                        label: const Text('تأجيل'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<ReminderBloc>().add(
                                UpdateMissedReminder(currentReminder.id),
                              );
                        },
                        child: const Text(
                          'تخطي',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}