import 'package:dosemate/core/constant/constant_colors.dart';
import 'package:dosemate/db/user.dart';
import 'package:dosemate/screens/add_screen.dart';
import 'package:dosemate/screens/caregivers_family_screen.dart';
import 'package:dosemate/screens/profile_screen.dart';
import 'package:dosemate/screens/today_screen.dart';
import 'package:flutter/material.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  List<Widget> screens = [
    TodayScreen(),
    AddScreen(),
    CaregiversFamilyScreen(),
    ProfileScreen(),
  ];

  Map<String, Widget> screenMap = {
    'اليوم': Icon(Icons.today),
    'اضافة': Icon(Icons.add),
    'المراقبه': Icon(Icons.health_and_safety),
    'الملف الشخصي': Icon(Icons.person),
  };
int index=0;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(


      body: IndexedStack(
        index:index,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        
        selectedItemColor: ConstantColors.primaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        
        items: screenMap.entries.map((screen)=>BottomNavigationBarItem(
          icon: screen.value,
          label: screen.key,
        
        )).toList(),
        onTap: (value){
          setState(() {
            index=value;
          });
        },
      ),
    );
  }
}