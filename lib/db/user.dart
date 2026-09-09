import 'package:dosemate/models/family_member.dart';
import 'package:dosemate/models/user.dart';

List<User> users = [
    User(
      name: 'سيف الدين',
      email: 'saif@example.com',
      password: 'Password123!',
      phone: '0791234567',
      dateOfBirth: DateTime(2002, 5, 15),
      gender: 'ذكر',
      createdAt: DateTime.now(),
    ),
    User(
      name: 'أحمد محمود',
      email: 'ahmad.m@domain.com',
      password: 'StrongUser99\$',
      phone: '0788765432',
      dateOfBirth: DateTime(1998, 11, 20),
      gender: 'ذكر',
      createdAt: DateTime.now(),
    ),
    User(
      name: 'سارة علي',
      email: 'sara.ali@gmail.com',
      password: 'StrongUser99\$',
      phone: '0770001122',
      dateOfBirth: DateTime(2000, 3, 10),
      gender: 'أنثى',
      createdAt: DateTime.now(),
    ),
  ];



  User? currentUser ; 


  List<FamilyMember> familyMembers = [];