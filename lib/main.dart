import 'package:flutter/material.dart';
import 'package:safeguard/screens/action/action_screen.dart';
import 'package:safeguard/screens/busstatus/bus_status_screen.dart';
import 'package:safeguard/screens/chat/chat_screen.dart';
import 'package:safeguard/screens/chatlist/chat_list_screen.dart';
import 'package:safeguard/screens/emergency/emergency_screen.dart';
import 'package:safeguard/screens/home/home_screen.dart';
import 'package:safeguard/screens/login/login_screen.dart';
import 'package:safeguard/screens/notes/notes_screen.dart';
import 'package:safeguard/screens/pda/pda_screen.dart';
import 'package:safeguard/screens/signup/signup_screen.dart';
import 'package:safeguard/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeGuard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routes: {
        "/" : (context) => const HomeScreen(),
        "/login" : (context) => const LoginScreen(),
        "/signup" : (context) => const SignUpScreen(),
        "/emergency" : (context) => const EmergencyScreen(),
        "/splash" : (context) => const SplashScreen(),
        "/pda" : (context) => const PDAScreen(),
        "/action": (context) => const ActionScreen(),
        "/chatlist": (context) => const ChatScreen(),
        "/chat": (context) => const ChatScreen(),
        "/busstatus": (context) => const BusStatusScreen(),
        "/notes" : (context) => NotesScreen()
      },
      initialRoute: "/splash",
    );
  }
}

