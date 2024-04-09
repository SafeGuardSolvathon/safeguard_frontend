import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                          Navigator.pushNamed(context,"/");
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