import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wallpaper_app/constants/app_routes.dart';

class NetworkErrorPage extends StatefulWidget {
  const NetworkErrorPage({super.key});

  @override
  State<NetworkErrorPage> createState() => _NetworkErrorPageState();
}

class _NetworkErrorPageState extends State<NetworkErrorPage> {
  bool isChecking = false;

  Color get primaryColor => const Color(0xff08122E);
  Color get accentColor => const Color(0xff5B4DFF);
  Color get softTextColor => const Color(0xff6B7280);
  Color get bgColor => const Color(0xffF5F7FF);

  Future<void> checkInternet() async {
    setState(() {
      isChecking = true;
    });

    final bool result =
    await InternetConnection().hasInternetAccess;

    if (!mounted) return;

    setState(() {
      isChecking = false;
    });

    if (result) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homePage,
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black.withOpacity(0.88),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: const Text(
            "Please check your internet connection and try again.",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
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
              accentColor.withOpacity(0.12),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -60,
            child: glowCircle(
              240,
              accentColor.withOpacity(0.08),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
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
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.08),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.18),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          size: 62,
                          color: accentColor,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        "No Internet Connection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Please connect internet and press refresh",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: softTextColor,
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 34),

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: isChecking ? null : checkInternet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            disabledBackgroundColor:
                            accentColor.withOpacity(0.7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: isChecking
                              ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.6,
                            ),
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Refresh",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
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