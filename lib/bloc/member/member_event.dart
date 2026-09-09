



import 'package:dosemate/models/user.dart';

abstract class MemberEvent {

}

class AddMemberByEmail extends MemberEvent {
  final String email;
  final currentUserId;
  AddMemberByEmail(this.email,this.currentUserId);
}


class DeleteMember extends MemberEvent
{
  final int id;
  DeleteMember(this.id);
}



