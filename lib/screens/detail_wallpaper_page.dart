import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_app/data/models/wallpaper_model.dart';
import 'package:wallpaper_app/ui_helper/ui_helper.dart';

import '../constants/app_routes.dart';

class DetailWallpaperPage extends StatefulWidget {
  @override
  State<DetailWallpaperPage> createState() => _DetailWallpaperPageState();
}

class _DetailWallpaperPageState extends State<DetailWallpaperPage> {
  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  Future<void> checkInternet() async {
    final result = await InternetConnection().hasInternetAccess;
    if (!result) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.networkErrorPage,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PhotoModel data =
        ModalRoute.of(context)!.settings.arguments as PhotoModel;

    final String imageUrl = data.src!.portrait!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(child: Image.network(imageUrl, fit: BoxFit.cover)),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.20),
                    Colors.transparent,
                    Colors.black.withOpacity(0.70),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            left: 18,

            child: InkWell(
              onTap: () {
                Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.pop(context);
                });
              },

              borderRadius: BorderRadius.circular(24),

              child: Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.28),

                  borderRadius: BorderRadius.circular(24),

                  border: Border.all(
                    color: Colors.white.withOpacity(0.14),
                    width: 1,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),

                    BoxShadow(
                      color: Colors.white.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(-1, -1),
                    ),
                  ],
                ),

                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 42,
            left: 18,
            right: 18,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getAction(
                    icon: Icons.info_outline_rounded,
                    onTap: () {},
                    title: "Info",
                  ),

                  getAction(
                    icon: Icons.download_rounded,
                    onTap: () => saveWallpaper(context, url: imageUrl),
                    title: "Save",
                  ),

                  getAction(
                    icon: Icons.wallpaper_rounded,
                    onTap: () =>
                        showApplyWallpaperSheet(context, url: imageUrl),
                    title: "Apply",
                    bgColor: Color(0xff5B4DFF),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAction({
    required IconData icon,
    required VoidCallback onTap,
    required String title,
    Color? bgColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: bgColor ?? Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),

        SizedBox(height: 8),

        Text(
          title,
          style: mTextStyle12(
            mColor: Colors.white,
            mFontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void showAppSnackBar(
    BuildContext context,
    String message, {
    IconData icon = Icons.info_outline_rounded,
    Color? color,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.88),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: (color ?? Color(0xff5B4DFF)).withOpacity(0.35),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),

              SizedBox(width: 12),

              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showApplyWallpaperSheet(BuildContext context, {required String url}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 22, 20, 30),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.92),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 24),

              Text(
                "Apply Wallpaper",
                style: mTextStyle16(
                  mColor: Colors.white,
                  mFontWeight: FontWeight.bold,
                ).copyWith(fontSize: 22),
              ),

              SizedBox(height: 8),

              Text(
                "Choose where you want to apply this wallpaper",
                textAlign: TextAlign.center,
                style: mTextStyle14(
                  mFontWeight: FontWeight.bold,
                  mColor: Colors.white.withOpacity(0.75),
                ),
              ),

              SizedBox(height: 26),

              Row(
                children: [
                  Expanded(
                    child: _applyOption(
                      icon: Icons.home_rounded,
                      title: "Home",
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                        applyWallpaper(context, url: url, type: "home");
                      },
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: _applyOption(
                      icon: Icons.lock_rounded,
                      title: "Lock",
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                        applyWallpaper(context, url: url, type: "lock");
                      },
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: _applyOption(
                      icon: Icons.phone_android_rounded,
                      title: "Both",
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 300), () {
                          Navigator.pop(context);
                        });
                        applyWallpaper(context, url: url, type: "both");
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _applyOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xff5B4DFF), size: 30),

            SizedBox(height: 8),

            Text(
              title,
              style: mTextStyle12(
                mColor: Colors.white,
                mFontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveWallpaper(
    BuildContext context, {
    required String url,
  }) async {
    try {
      showAppSnackBar(
        context,
        "Saving wallpaper...",
        icon: Icons.download_rounded,
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        showAppSnackBar(
          context,
          "Image download failed",
          icon: Icons.error_outline_rounded,
          color: Colors.redAccent,
        );
        return;
      }

      final result = await ImageGallerySaverPlus.saveImage(
        response.bodyBytes,
        quality: 100,
        name: "wallpaper_${DateTime.now().millisecondsSinceEpoch}",
      );

      final bool isSuccess =
          result["isSuccess"] == true || result["isSuccess"] == 1;

      showAppSnackBar(
        context,
        isSuccess ? "Wallpaper saved!" : "Wallpaper not saved",
        icon: isSuccess
            ? Icons.check_circle_rounded
            : Icons.error_outline_rounded,
        color: isSuccess ? Colors.greenAccent : Colors.redAccent,
      );
    } catch (e) {
      debugPrint("Save Error: $e");

      showAppSnackBar(
        context,
        "Save failed",
        icon: Icons.error_outline_rounded,
        color: Colors.redAccent,
      );
    }
  }

  void applyWallpaper(
    BuildContext context, {
    required String url,
    required String type,
  }) {
    final size = MediaQuery.sizeOf(context);

    showAppSnackBar(
      context,
      "Applying wallpaper...",
      icon: Icons.wallpaper_rounded,
    );

    Wallpaper.imageDownloadProgress(url).listen(
      (progress) {
        debugPrint("Wallpaper download progress: $progress");
      },
      onDone: () async {
        try {
          if (type == "home") {
            await Wallpaper.homeScreen(
              width: size.width,
              height: size.height,
              options: RequestSizeOptions.resizeFit,
            );
          } else if (type == "lock") {
            await Wallpaper.lockScreen(
              width: size.width,
              height: size.height,
              options: RequestSizeOptions.resizeFit,
            );
          } else {
            await Wallpaper.bothScreen(
              width: size.width,
              height: size.height,
              options: RequestSizeOptions.resizeFit,
            );
          }

          showAppSnackBar(
            context,
            "Wallpaper applied successfully",
            icon: Icons.check_circle_rounded,
            color: Colors.greenAccent,
          );
        } catch (e) {
          debugPrint("Apply Error: $e");

          showAppSnackBar(
            context,
            "Wallpaper apply failed",
            icon: Icons.error_outline_rounded,
            color: Colors.redAccent,
          );
        }
      },
      onError: (e) {
        debugPrint("Download Error: $e");

        showAppSnackBar(
          context,
          "Download failed",
          icon: Icons.wifi_off_rounded,
          color: Colors.redAccent,
        );
      },
    );
  }
}
