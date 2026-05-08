import 'package:wallpaper_app/data/remote/api_helper.dart';
import 'package:wallpaper_app/data/remote/urls.dart';

class WallpaperRepository {
  ApiHelper apiHelper;

  WallpaperRepository({required this.apiHelper});

  Future<dynamic> getSearchWallpaper({
    required String mQuery,
    String mColor = "",
    int page=1
  }) async {
    try {
      String url = "${AppUrls.SEARCH_URL}?query=$mQuery&page=$page";
      if (mColor.isNotEmpty) {
        url += "&color=$mColor";
      }
      return await apiHelper.getApi(
        url: url,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTrendingWallpaper() async {
    try {
      return await apiHelper.getApi(
        url: "${AppUrls.TREND_WALL_URL}?per_page=80",
      );
    } catch (e) {
      rethrow;
    }
  }
}
