import 'package:bloc/bloc.dart';
import 'package:dosemate/bloc/reminder/reminder_event.dart';
import 'package:dosemate/bloc/reminder/reminder_state.dart';
import 'package:dosemate/models/dose_reminder.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial()) 
{
  on<AddReminder>((event,emit){
    emit(ReminderUpdated([...state.reminders, event.model]));
  });

  on<DeleteReminder>((event,emit){
    List<DoseReminder> newReminders = state.reminders.where((reminder) => reminder.id != event.id).toList();
    emit(ReminderUpdated(newReminders));
  });

  on<UpdateTakeReminder>((event,emit){
    List<DoseReminder>newReminders=state.reminders.map((reminder)=>reminder.id == event.id ? reminder.copyWith(status: 'taken') : reminder).toList();
    emit(ReminderUpdateSuccess('تم اخذ الدواء', newReminders));
  });

  on<UpdateSnoozeReminder>((event,emit){
    
    List<DoseReminder>newReminders=state.reminders.map((reminder)=>reminder.id == event.id ? reminder.copyWith(status: 'snoozed',snoonzedUntil: event.snoozedUntil) : reminder).toList();
    emit(ReminderUpdateSuccess('تم التأجيل', newReminders));
  });

  on<UpdateMissedReminder>((event,emit){
    List<DoseReminder>newReminders=state.reminders.map((reminder)=>reminder.id == event.id ? reminder.copyWith(status: 'missed') : reminder).toList();
    emit(ReminderUpdateSuccess('نسيت الدواء', newReminders));
  });
}
  
}