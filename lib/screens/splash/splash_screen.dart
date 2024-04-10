import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkUserLoggedIn() async {
    // Check if user details are stored in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.containsKey('empId');

    // Navigate to the appropriate screen based on whether user is logged in or not
    isLoggedIn
        ? Navigator.pushReplacementNamed(context, '/')
        : null; //  // Replace '/login' with your login screen route
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E4F7),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Column(
                children: [
                  Image(
                    image: AssetImage(
                      "assets/images/logo.png",
                    ),
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "SafeGuard",
                    style: GoogleFonts.poppins(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Digital Companion for Guards",
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Image.asset(
              "assets/images/security.png",
              height: 250,
              fit: BoxFit.contain,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF59718F),
                  borderRadius: BorderRadius.circular(10)),
              child: MaterialButton(
                  child: Center(
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  }),
            )
          ],
        ),
      ),
    );
  }
}
