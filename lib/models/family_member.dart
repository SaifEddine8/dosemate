import 'package:dosemate/models/user.dart';

class FamilyMember {
  final int trackerId;     
  final User member; 

  FamilyMember({
    required this.trackerId,
    required this.member,
  });
}