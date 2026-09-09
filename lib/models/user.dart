import 'package:dosemate/models/dose_reminder.dart';
import 'package:dosemate/models/family_member.dart';

class User {
  static int _idCounter = 0;
  int id;
  String name;
  String email;
  String password;
  String? phone;
  DateTime? dateOfBirth;
  String? gender;
  DateTime createdAt;
  List<FamilyMember> familyMembers;
  User({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.dateOfBirth,
    this.gender,
    required this.createdAt,
    this .familyMembers=const[],
  }):id = _idCounter++;
}