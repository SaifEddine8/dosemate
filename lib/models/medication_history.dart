

// enum MedicationStatus { taken, missed, skipped }



// class MedicationHistory {
//   static int _idCounter = 0;
//   int id;
//   int medicationId;
//   String reminderId;
//   DateTime scheduledTime;
//   DateTime? takenTime;
//   MedicationStatus status; 
//   MedicationHistory({
//     required this.medicationId,
//     required this.reminderId,
//     required this.scheduledTime,
//     this.takenTime,
//     required this.status,
//   }) : id = _idCounter++;
// }