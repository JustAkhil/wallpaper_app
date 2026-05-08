import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_app/data/models/wallpaper_model.dart';
import 'package:wallpaper_app/ui_helper/ui_helper.dart';

class DetailWallpaperPage extends StatelessWidget {
  const DetailWallpaperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PhotoModel data =
    ModalRoute.of(context)!.settings.arguments as PhotoModel;
    final String imageUrl =
            data.src!.portrait!;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 20,
            top: 50,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.4),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getAction(
                  icon: Icons.info_outlined,
                  onTap: () {},
                  title: "Info",
                ),
                getAction(
                  icon: Icons.download_sharp,
                  onTap: () =>
                      saveWallpaper(context, url: imageUrl),
                  title: "Save",
                ),
                getAction(
                  icon: Icons.format_paint_sharp,
                  onTap: () =>
                      applyWallpaper(context, url: imageUrl),
                  title: "Apply",
                  bgColor: Colors.blueAccent,
                ),
              ],
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
          borderRadius: BorderRadius.circular(11),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color:
              bgColor ??
                  Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: mTextStyle12(
            mColor: Colors.white,
            mFontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  Future<void> saveWallpaper(
      BuildContext context, {
        required String url,
      }) async {

    final messenger = ScaffoldMessenger.of(context);

    try {

      messenger.showSnackBar(
        const SnackBar(
          content: Text("Saving wallpaper..."),
        ),
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text("Image download failed"),
          ),
        );
        return;
      }

      final result =
      await ImageGallerySaverPlus.saveImage(
        response.bodyBytes,
        quality: 100,
        name:
        "wallpaper_${DateTime.now().millisecondsSinceEpoch}",
      );

      final bool isSuccess =
          result["isSuccess"] == true ||
              result["isSuccess"] == 1;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            isSuccess
                ? "Wallpaper saved!"
                : "Wallpaper not saved",
          ),
        ),
      );
    } catch (e) {

      debugPrint("Save Error: $e");

      messenger.showSnackBar(
        const SnackBar(
          content: Text("Save failed"),
        ),
      );
    }
  }

  /// Apply Wallpaper
  void applyWallpaper(
      BuildContext context, {
        required String url,
      }) {

    final messenger = ScaffoldMessenger.of(context);
    final size = MediaQuery.sizeOf(context);

    messenger.showSnackBar(
      const SnackBar(
        content: Text("Applying wallpaper..."),
      ),
    );

    Wallpaper.imageDownloadProgress(url).listen(

          (progress) {
        debugPrint(
          "Wallpaper download progress: $progress",
        );
      },

      onDone: () async {

        try {

          await Wallpaper.homeScreen(
            width: size.width,
            height: size.height,
            options: RequestSizeOptions.resizeFit,
          );

          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                "Wallpaper applied successfully",
              ),
            ),
          );

        } catch (e) {

          debugPrint("Apply Error: $e");

          messenger.showSnackBar(
            const SnackBar(
              content: Text("Wallpaper apply failed"),
            ),
          );
        }
      },

      onError: (e) {

        debugPrint("Download Error: $e");

        messenger.showSnackBar(
          const SnackBar(
            content: Text("Download failed"),
          ),
        );
      },
    );
  }
}