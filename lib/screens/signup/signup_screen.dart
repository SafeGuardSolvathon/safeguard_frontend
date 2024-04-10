import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  bool isSecure = true;

  Future<void> handleSignUp() async {
    final url = "http://10.0.2.2:8000/users/";
    final Map<String, dynamic> userData = {
      'username': fullNameController.text,
      'password': passwordController.text,
      'empid': employeeIdController.text
      // Add more fields as required by your backend
    };
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData));
    if (response.statusCode == 201) {
      // Successfully signed up
      final Map<String, dynamic> responseData = json.decode(response.body);
      final userDetails = responseData['details'];

      // Store user details in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('empId', userDetails['empId']);
      prefs.setString('fullName', userDetails['fullName']);
      Navigator.pushNamed(context, "/");
      // Navigate to the next screen or perform any desired action
    } else {
      // Failed to sign up
      final Map<String, dynamic> errorData = json.decode(response.body);
      final errorMessage = errorData['error'];
      // Display error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E4F7),
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              "assets/images/logo.png",
              height: 30,
              fit: BoxFit.contain,
            ),
          )
        ],
        backgroundColor: const Color(0xFFD4E4F7),
        title: Text(
          "SIGN UP",
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w600, fontSize: 25, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello!",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                  Text(
                    "Create account to entering the following details",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Full Name",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                      controller: fullNameController,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Rakesh",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.grey))),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Employee Id",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                      controller: employeeIdController,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "S101",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.grey))),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Password",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                      obscureText: isSecure,
                      controller: passwordController,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isSecure = !isSecure;
                                });
                              },
                              icon: Icon(isSecure
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Password",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.grey))),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF59718F),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          handleSignUp();
                        },
                        child: Center(
                            child: Text(
                          "Create Account",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                        )),
                      )),
                  SizedBox(
                    height: 130,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Already have an account ?   ",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF2B3B4E))),
                        TextSpan(
                            text: "Login",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2B3B4E)))
                      ])),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
