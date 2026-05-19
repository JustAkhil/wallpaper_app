import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/screens/on_boarding/bloc/authenticate_bloc.dart';
import 'package:wallpaper_app/screens/on_boarding/bloc/authenticate_state.dart';

import '../../../constants/app_routes.dart';
import '../bloc/authenticate_event.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color accentColor = Color(0xff5B4DFF);
  final Color bgColor = Color(0xffF5F7FF);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  bool isPasswordHidden = true;
  GlobalKey<FormState> key = GlobalKey();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Login to continue",
                    style: TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 160),
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
                                return "Enter Email";
                              } else {
                                return null;
                              }
                            }),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: "Email Address",
                              filled: true,
                              fillColor: bgColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                          TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              }
                              return null;
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
                                borderSide: BorderSide(color: Colors.red),
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

                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.forgotPasswordPage,
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
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
                                          context.read<AuthenticateBloc>().add(
                                            LoginUserEvent(
                                              email: emailController.text,
                                              pass: passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                              trackGap: 3,
                                              strokeWidth: 3,
                                            )
                                          : Text(
                                              "Login",
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).hideCurrentSnackBar();

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                                    if (state is LoginSuccessState) {
                                      isLoading = false;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        _customSnackBar(
                                          message: "Login Successfully!!",
                                          icon: Icons.check_circle_rounded,
                                          colors: [
                                            Color(0xff667EEA),
                                            Color(0xff764BA2),
                                          ],
                                          textColor: Colors.white,
                                        ),
                                      );
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.homePage,
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
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.signupPage);
                        },
                        child: Text(
                          "Sign Up",
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(colors: colors),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.28),
              blurRadius: 16,
              spreadRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            SizedBox(width: 10),
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
