import 'package:dosemate/db/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dosemate/bloc/member/member_bloc.dart';
import 'package:dosemate/bloc/member/member_event.dart';
import 'package:dosemate/bloc/member/member_state.dart';

import 'package:dosemate/bloc/reminder/reminder_bloc.dart';
import 'package:dosemate/bloc/reminder/reminder_state.dart';

import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';
import 'package:dosemate/models/dose_reminder.dart';

class CaregiversFamilyScreen extends StatelessWidget {
  const CaregiversFamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.tertiaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الأشخاص والمراقبة',
          style: AppStyles.pageTitle.copyWith(
            color: ConstantColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ConstantColors.primaryColor,
        onPressed: () {
          final emailController = TextEditingController();
          final relationController = TextEditingController();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (bottomSheetContext) {
              return Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ربط شخص للمراقبة',
                      style: AppStyles.subtitle.copyWith(
                        color: ConstantColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني للشخص',
                        hintText: 'example@email.com',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: relationController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: 'الفئة / صلة القرابة',
                        hintText: 'مثال: أب، أخت، مريض',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantColors.primaryColor,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: () {
                        final email = emailController.text.trim();
                        if (email.isNotEmpty) {
                          context.read<MemberBloc>().add(
                                AddMemberByEmail(email,currentUser!.id),
                              );
                        }
                        Navigator.of(bottomSheetContext).pop();
                      },
                      child: const Text('متابعة', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          );
        },
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        label: const Text(
          'إضافة شخص',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<MemberBloc, MemberState>(
        listener: (context, memberState) {
          if (memberState is MemberError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(memberState.message, textAlign: TextAlign.right),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          if (memberState is UpdateMember) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(memberState.message, textAlign: TextAlign.right),
                backgroundColor: Colors.teal,
              ),
            );
          }
        },
        builder: (context, memberState) {
          final usersList = memberState.members.where((member)=>member.trackerId==currentUser!.id).toList();

          if (usersList.isEmpty) {
            return Center(
              child: Text(
                'لا يوجد أشخاص قيد المراقبة حالياً',
                style: AppStyles.subtitle.copyWith(color: Colors.grey.shade600),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            physics: const BouncingScrollPhysics(),
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              final user = usersList[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: ConstantColors.primaryColor.withOpacity(0.15),
                            child: Text(
                              user.member.name.isNotEmpty ? user.member.name.toUpperCase() : '?',
                              style: TextStyle(
                                color: ConstantColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  user.member.email,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.grey),
                            onSelected: (value) {
                              if (value == 'delete') {
                                context.read<MemberBloc>().add(DeleteMember(user.member.id));
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                    SizedBox(width: 8),
                                    Text('إزالة المراقبة', style: TextStyle(color: Colors.redAccent)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      BlocConsumer<ReminderBloc, ReminderState>(
                        listener: (context, reminderState) {
                          if (reminderState is ReminderUpdateSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(reminderState.message, textAlign: TextAlign.right),
                                backgroundColor: Colors.teal,
                              ),
                            );
                          }
                          if (reminderState is ReminderError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(reminderState.message, textAlign: TextAlign.right),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        builder: (context, reminderState) {
                          final userReminders = reminderState.reminders
                              .where((reminder) => reminder.userId == user.member.id)
                              .toList();

                          final int totalDoses = userReminders.length;
                          final int takenDoses = userReminders
                              .where((r) => r.status == 'taken')
                              .toList()
                              .length;

                          final double progress = totalDoses > 0 ? (takenDoses / totalDoses) : 0.0;
                          final bool hasMissedDose = userReminders.any((r) => r.status == 'missed');

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'التزام اليوم:',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                  Text(
                                    '$takenDoses من $totalDoses جرعات (${(progress * 100).toInt()}%)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: hasMissedDose ? Colors.orange.shade800 : Colors.teal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    hasMissedDose ? Colors.orange.shade700 : Colors.teal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              if (userReminders.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ConstantColors.tertiaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:  NeverScrollableScrollPhysics(),
                                    itemCount: userReminders.length,
                                    separatorBuilder: (context, index) => const Divider(height: 12),
                                    itemBuilder: (context, index) {
                                      final reminder = userReminders[index];
                                      final status = reminder.status ?? 'pending';

                                      return _buildDoseTile(
                                        doseName: reminder.name ?? 'جرعة دواء',
                                        statusColor: status == 'pending'
                                            ? const Color.fromARGB(255, 117, 117, 117)
                                            : (status == 'taken'
                                                ? ConstantColors.primaryColor
                                                : const Color.fromARGB(255, 255, 82, 82)),
                                        icon: status == 'pending'
                                            ? Icons.access_time
                                            : (status == 'taken'
                                                ? Icons.check_circle_outline
                                                : Icons.warning_amber_rounded),
                                        statusText: status == 'pending'
                                            ? 'القادمة'
                                            : (status == 'taken' ? 'أخذت' : 'لم تؤخذ (متأخر)'),
                                        time: reminder.reminderTime.format(context) ?? '--:--',
                                      );
                                    },
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'لا توجد جرعات مسجلة لهذا الشخص اليوم',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                ),

                              const SizedBox(height: 14),

                              if (hasMissedDose)
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.orange.shade800,
                                      side: BorderSide(color: Colors.orange.shade400),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'تم إرسال إشعار تذكير إلى ${user.member.name}',
                                            textAlign: TextAlign.right,
                                          ),
                                          backgroundColor: Colors.orange.shade800,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.notifications_active_outlined, size: 18),
                                    label: const Text(
                                      'إرسال تذكير بالجرعة المتأخرة',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDoseTile({
    required String doseName,
    required String time,
    required String statusText,
    required Color statusColor,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: statusColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doseName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}