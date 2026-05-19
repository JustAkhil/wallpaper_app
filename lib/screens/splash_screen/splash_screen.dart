import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/constants/app_routes.dart';
import 'package:wallpaper_app/data/repository/firebase-repository.dart';

import '../network_error.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _loaderController;

  Color get primaryColor => const Color(0xff08122E);
  Color get accentColor => const Color(0xff5B4DFF);
  Color get softTextColor => const Color(0xff6B7280);
  Color get bgColor => const Color(0xffF5F7FF);

  @override
  void initState() {
    super.initState();

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    checkInternetAndNavigate();
  }

  Future<void> checkInternetAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final bool hasInternet =
    await InternetConnection().hasInternetAccess;

    if (!mounted) return;

    if (hasInternet) {
      SharedPreferences prefs=await SharedPreferences.getInstance();
      final user = prefs.getString(FirebaseRepository.PREFS_USER_ID_KEY);

      Navigator.pushReplacementNamed(
        context,
        (user != null && user.isNotEmpty)
            ? AppRoutes.homePage
            : AppRoutes.loginPage,
      );
    } else {
     Navigator.pushReplacementNamed(context,AppRoutes.networkErrorPage);
    }
  }

  @override
  void dispose() {
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -70,
            child: glowCircle(
              260,
              accentColor.withOpacity(0.14),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -60,
            child: glowCircle(
              240,
              accentColor.withOpacity(0.10),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 38,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(34),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.22),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(34),
                          child: Image.asset(
                            "assets/image/splash_image.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "WallNest",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Curated wallpapers for your screen",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: softTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 38),

                      AnimatedBuilder(
                        animation: _loaderController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _loaderController.value * 2 * pi,
                            child: CustomPaint(
                              size: const Size(60, 60),
                              painter: PremiumCircleLoaderPainter(
                                accentColor: accentColor,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "Loading...",
                        style: TextStyle(
                          color: softTextColor,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class PremiumCircleLoaderPainter extends CustomPainter {
  final Color accentColor;

  PremiumCircleLoaderPainter({
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = const Color(0xffEEF0F6)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final loaderPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          accentColor.withOpacity(0.05),
          accentColor.withOpacity(0.35),
          accentColor,
          const Color(0xff7C74FF),
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      )
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 4, bgPaint);

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius - 4,
      ),
      -pi / 2,
      pi * 1.55,
      false,
      loaderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}