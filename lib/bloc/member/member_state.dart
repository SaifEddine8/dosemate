



import 'package:dosemate/models/family_member.dart';
import 'package:dosemate/models/user.dart';

abstract class MemberState {
final List<FamilyMember>members;
MemberState(this.members);
}
class MemberInit extends MemberState{
MemberInit():super([]);
}


class UpdateMember extends MemberState {
  final String message;
  UpdateMember(this.message,super.reminders);
}
class MemberError extends MemberState{
  String message;
  MemberError(this.message,super.users);
}