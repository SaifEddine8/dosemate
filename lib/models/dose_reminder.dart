import 'package:flutter/material.dart';

class DoseReminder {
  static int _idCounter = 0;
  int id;
  final int userId;
  String name;
  int medicationId;
  TimeOfDay reminderTime;
  String frequency;
  DateTime startDate;
  DateTime? endDate;
  bool isActive;
  double dosageAmount;

  String status; 
  DateTime? snoonzedUntil; 

  DoseReminder({
    required this.name,
    required this.userId,
    required this.medicationId,
    required this.reminderTime,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.dosageAmount,
    this.status = 'pending',
    this.snoonzedUntil,
    id
  }) : id = _idCounter++;


  DoseReminder copyWith({
    int? id,
    String?name,
    int?userId,
    int? medicationId,
    TimeOfDay? reminderTime,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    double? dosageAmount,
    String? status,
    DateTime? snoonzedUntil,
  }) {
    return DoseReminder(
      id: id ?? this.id,
      name:name??this.name,
      userId: userId??this.userId,
      medicationId: medicationId ?? this.medicationId,
      reminderTime: reminderTime ?? this.reminderTime,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      dosageAmount: dosageAmount ?? this.dosageAmount,
      status: status ?? this.status,
      snoonzedUntil: snoonzedUntil ?? this.snoonzedUntil,
    );
  }
}