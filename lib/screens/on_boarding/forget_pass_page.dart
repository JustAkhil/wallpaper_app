import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/repository/firebase-repository.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool isLoading = false;

  Color get primaryColor => Color(0xff08122E);

  Color get accentColor => Color(0xff5B4DFF);

  Color get bgColor => Color(0xffF5F7FF);

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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Enter your email to reset password",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              SizedBox(height: 40),

              Container(
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 25,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      cursorColor: accentColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xffF5F7FF),
                      ),
                    ),

                    SizedBox(height: 25),
                    InkWell(
                      onTap: () async {
                              String email = emailController.text;

                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  _customSnackBar(
                                    message: "Enter email",
                                    icon: Icons.error,
                                    colors: [
                                      Color(0xffFF6B6B),
                                      Color(0xffFF8E53),
                                    ],
                                    textColor: Colors.white,
                                  ),
                                );
                                return;
                              }

                              if (!email.contains("@")) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  _customSnackBar(
                                    message: "Enter valid email",
                                    icon: Icons.warning,
                                    colors: [
                                      Color(0xffFF6B6B),
                                      Color(0xffFF8E53),
                                    ],
                                    textColor: Colors.white,
                                  ),
                                );
                                return;
                              }

                              setState(() => isLoading = true);

                              try {
                                await FirebaseRepository.getInstance()
                                    .sendPasswordResetLink(email: email);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  _customSnackBar(
                                    message: "Reset link sent successfully",
                                    icon: Icons.check_circle,
                                    colors: [
                                      Color(0xff5B4DFF),
                                      Color(0xff7C74FF),
                                    ],
                                    textColor: Colors.white,
                                  ),
                                );

                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  _customSnackBar(
                                    message: e.toString(),
                                    icon: Icons.close,
                                    colors: [
                                      Color(0xffFF6B6B),
                                      Color(0xffFF8E53),
                                    ],
                                    textColor: Colors.white,
                                  ),
                                );

                                setState(() => isLoading = false);
                              }
                            },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.4),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Send Reset Link",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
