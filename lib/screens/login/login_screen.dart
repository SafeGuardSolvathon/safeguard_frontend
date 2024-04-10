import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    // Define the API endpoint URL
    final String apiUrl = 'http://10.0.2.2:8000/login/';

    try {
      // Send a POST request to the backend endpoint
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'empid': employeeIdController.text,
          'password': passwordController.text
        }),
        headers: {'Content-Type': 'application/json'},
      );

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response JSON data
        final responseData = jsonDecode(response.body);

        // Check if the login was successful
        if (responseData['success'] == true) {
          // Extract user details from the response
          final userDetails = responseData['details'];

          // Store user details in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('empId', userDetails['empid']);
          prefs.setString('fullName', userDetails['username']);
          Navigator.pushNamed(context, "/");
          // TODO: Handle user authentication and navigation based on the response
          // For example, you can store user details in local storage and navigate to the home screen
        } else {
          // Handle unsuccessful login (invalid credentials)
          // For example, show an error message to the user
          print('Invalid username or password');
        }
      } else {
        // Handle other HTTP status codes (e.g., server error)
        // For example, show an error message to the user
        print('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      // For example, show an error message to the user
      print('Error: $e');
    }
  }

  bool isSecure = true;
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
          "LOGIN",
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
                    "Hello, Welcome Back",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                  Text(
                    "Happy to see you again, kindly enter your registered employee id and password",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
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
                    height: 50,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF59718F),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          loginUser();
                        },
                        child: Center(
                            child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                        )),
                      )),
                  SizedBox(
                    height: 200,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Don't have an account ?   ",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF2B3B4E))),
                        TextSpan(
                            text: "Sign Up",
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
