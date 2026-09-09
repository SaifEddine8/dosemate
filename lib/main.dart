import 'package:dosemate/bloc/member/member_bloc.dart';
import 'package:dosemate/bloc/reminder/reminder_bloc.dart';
import 'package:dosemate/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp( MultiBlocProvider(
    providers: [
      BlocProvider(
      create: (context) => ReminderBloc(),
      
    ),
    BlocProvider(create: (context)=>MemberBloc())
    ],
    child: MaterialApp(
    home: SplashScreen()
    ),
  )
  );
}
