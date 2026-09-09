


import 'package:dosemate/bloc/member/member_event.dart';
import 'package:dosemate/bloc/member/member_state.dart';
import 'package:dosemate/db/user.dart';
import 'package:dosemate/models/family_member.dart';
import 'package:dosemate/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberBloc extends Bloc<MemberEvent,MemberState>{
MemberBloc():super(MemberInit())
{
  on<AddMemberByEmail>((event,emit){
    final existingIndex=users.indexWhere((user)=>user.email.trim().toLowerCase()==event.email.trim().toLowerCase());
    if(existingIndex!=-1)
    {
      final foundUser=users[existingIndex];
      if (foundUser.id == event.currentUserId) {
      emit(MemberError('لا يمكنك إضافة حسابك الحالي كعضو مراقب', state.members));
      return;
    }
    final isAlreadyAdded = state.members.any(
      (m) => m.member.id == foundUser.id && m.trackerId == event.currentUserId,
    );
    if (isAlreadyAdded) {
      emit(MemberError('هذا المريض مضاف مسبقاً لقائمتك', state.members));
      return;
    }
    final newMember=FamilyMember(
      member: foundUser,
      trackerId: currentUser!.id
    );
      
      emit(UpdateMember('تمت اضافة المريض',[...state.members,newMember ]));
    }
    else{
      emit(MemberError('البريد الالكتروني للمريض خطأ',state.members));
    }

    
  });


  on<DeleteMember>((event,emit){
    List<FamilyMember> newMember = state.members.where((user) => user.member.id != event.id).toList();
    emit(UpdateMember('تم حذف المريض',newMember));
  });
}


}