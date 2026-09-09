import 'package:dosemate/models/dose_reminder.dart';
import 'package:dosemate/db/reminder.dart';
abstract class ReminderState {
  final List<DoseReminder>reminders;
  ReminderState(
    this.reminders,
  );
}
class ReminderInitial extends ReminderState {
  ReminderInitial()
      : super([]);
}
class ReminderUpdated extends ReminderState {

  ReminderUpdated(super.reminders);
}




class ReminderError extends ReminderState {
  final String message;
  ReminderError(this.message,super.reminders);
}



class ReminderUpdateSuccess extends ReminderState {
  final String message;
  ReminderUpdateSuccess(this.message,super.reminders);
}