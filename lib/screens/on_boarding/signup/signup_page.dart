import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/constants/app_routes.dart';
import 'package:wallpaper_app/data/models/user_model.dart';
import 'package:wallpaper_app/screens/on_boarding/bloc/authenticate_bloc.dart';
import 'package:wallpaper_app/screens/on_boarding/bloc/authenticate_event.dart';
import 'package:wallpaper_app/screens/on_boarding/bloc/authenticate_state.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final Color primaryColor = Color(0xff08122E);
  final Color accentColor = Color(0xff5B4DFF);
  final Color bgColor = Color(0xffF5F7FF);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  GlobalKey<FormState> key = GlobalKey();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: Stack(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, Color(0xff7C74FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Sign up to get started",
                    style: TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 70),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 25,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Form(
                      key: key,
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return "Enter Name";
                              }
                              return null;
                            }),
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: "Full Name",
                              filled: true,
                              fillColor: bgColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                    color: Colors.red
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: ((value) {
                              if (value!.length != 10) {
                                return "Enter Valid Number";
                              }
                              return null;
                            }),
                            controller: phoneController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              hintText: "Mobile Number",
                              filled: true,
                              fillColor: bgColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                    color: Colors.red
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                          TextFormField(
                            validator: ((value) {
                              RegExp regEx = RegExp(
                                r'^[a-zA-Z0-9.]+@gmail\.com$',
                              );
                              if (value!.isEmpty) {
                                return "Enter Email";
                              }
                              if (!regEx.hasMatch(value)) {
                                return "Invalid Email";
                              }
                              return null;
                            }),
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: "Email",
                              filled: true,
                              fillColor: bgColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                    color: Colors.red
                                ),
                              ),
                            ),

                          ),

                          SizedBox(height: 20),
                          TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              } else {
                                return null;
                              }
                            }),
                            controller: passwordController,
                            obscureText: isPasswordHidden,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Password",
                              filled: true,
                              fillColor: bgColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,

                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                    color: Colors.red
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordHidden = !isPasswordHidden;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: ((value) {
                              if (value != passwordController.text) {
                                return "Password not match";
                              }if (value!.isEmpty) {
                                return "Enter Password";
                              }
                              return null;
                            }),
                            controller: confirmPasswordController,
                            obscureText: isConfirmPasswordHidden,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Password",
                              filled: true,
                              fillColor: bgColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                    color: Colors.red
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordHidden =
                                        !isConfirmPasswordHidden;
                                  });
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: 25),
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [accentColor, Color(0xff7C74FF)],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child:
                                BlocConsumer<
                                  AuthenticateBloc,
                                  AuthenticateState
                                >(
                                  builder: (_, state) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (key.currentState!.validate()) {
                                          UserModel user = UserModel(
                                            email: emailController.text,
                                            mobNo: phoneController.text,
                                            name: nameController.text,
                                          );
                                          context.read<AuthenticateBloc>().add(
                                            CreateUserEvent(
                                              userModel: user,
                                              pass: passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                      child: isLoading
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : Text(
                                              "Sign Up",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                    );
                                  },
                                  listener: (_, state) {
                                    if (state is AuthenticateLoadingState) {
                                      isLoading = true;
                                      setState(() {});
                                    }
                                    if (state is AuthenticationErrorState) {
                                      isLoading = false;
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        _customSnackBar(
                                          message: state.errMsg,
                                          icon: Icons.error_rounded,
                                          colors: [
                                            Color(0xffFF6B6B),
                                            Color(0xffFF8E53),
                                          ],
                                          textColor: Colors.white,
                                        ),
                                      );
                                      setState(() {});
                                    }
                                    if (state is CreateAccountSuccessState) {
                                      isLoading = false;
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        _customSnackBar(
                                          message: "Account Created Successfully!!",
                                          icon: Icons.check_circle_rounded,
                                          colors: const [
                                            Color(0xff667EEA),
                                            Color(0xff764BA2),
                                          ],
                                          textColor: Colors.white,
                                        ),
                                      );
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.loginPage,
                                      );
                                    }
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.loginPage);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  SnackBar _customSnackBar({
    required String message,
    required IconData icon,
    required List<Color> colors,
    required Color textColor,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(colors: colors),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.28),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
