import 'package:dosemate/db/user.dart';
import 'package:dosemate/models/dose_reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dosemate/bloc/reminder/reminder_bloc.dart';
import 'package:dosemate/bloc/reminder/reminder_state.dart';
import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: ConstantColors.primaryColor, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppStyles.subtitle.copyWith(
            fontWeight: FontWeight.bold,
            color: ConstantColors.primaryColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppStyles.small.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderBloc, ReminderState>(
      builder: (context, state) {
        final userReminders = currentUser == null 
          ? <DoseReminder>[] 
          : state.reminders.where((r) => r.userId == currentUser!.id).toList();
        final activeMedsCount = userReminders.map((r) => r.medicationId).toSet().length;
        final todayDosesCount = userReminders.length;
        final takenCount = userReminders.where((r) => r.status == 'taken').length;
        final double adherencePercentage =
            todayDosesCount > 0 ? (takenCount / todayDosesCount) * 100 : 0;

        return Row(
          mainAxisAlignment: .spaceAround,
          children: [
            _buildStatItem('الأدوية النشطة', '$activeMedsCount', Icons.medication),
            Container(height: 30, width: 1, color: Colors.grey.shade300),
            _buildStatItem(
              'نسبة الالتزام',
              '${adherencePercentage.toStringAsFixed(0)}%',
              Icons.verified,
            ),
            Container(height: 30, width: 1, color: Colors.grey.shade300),
            _buildStatItem('جرعات اليوم', '$todayDosesCount', Icons.alarm),
          ],
        );
      },
    );
  }
}