import 'package:dosemate/models/dose_reminder.dart';

abstract class ReminderEvent {

}

class AddReminder extends ReminderEvent {
  final DoseReminder model;
  AddReminder(this.model);
}

class UpdateTakeReminder extends ReminderEvent {
  final int id;
  UpdateTakeReminder(this.id);}

class UpdateSnoozeReminder extends ReminderEvent {
  final int id;
  final DateTime? snoozedUntil;
  UpdateSnoozeReminder(this.id, this.snoozedUntil);
  }


class UpdateMissedReminder extends ReminderEvent {
  final int id;
  UpdateMissedReminder(this.id,);}




class DeleteReminder extends ReminderEvent {
  final int id;
  DeleteReminder(this.id);
}



