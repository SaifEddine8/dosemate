import 'package:dosemate/core/constant/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:dosemate/core/constant/app_style.dart';

class ReminderTimesPicker extends StatelessWidget {
  final List<TimeOfDay> selectedTimes;
  final VoidCallback onAddTime;
  final ValueChanged<int> onRemoveTime;

  const ReminderTimesPicker({
    super.key,
    required this.selectedTimes,
    required this.onAddTime,
    required this.onRemoveTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            const Text('أوقات التنبيه', style: AppStyles.subtitle),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAddTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ConstantColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: ConstantColors.primaryColor.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_alarm_rounded, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'إضافة وقت',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (selectedTimes.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFA6E3E9).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ConstantColors.primaryColor.withOpacity(0.15),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.alarm_add, color: Colors.grey.shade400, size: 20),
                const SizedBox(width: 8),
                Text(
                  'اضغط على زر "إضافة وقت" لتحديد مواعيد التنبيه',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(selectedTimes.length, (index) {
              final time = selectedTimes[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ConstantColors.primaryColor.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time_filled_rounded, size: 16, color: ConstantColors.primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      time.format(context),
                      style: const TextStyle(
                        color: ConstantColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onRemoveTime(index),
                      child: const Icon(Icons.highlight_remove_rounded, size: 18, color: Colors.redAccent),
                    ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }
}