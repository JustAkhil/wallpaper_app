import 'package:flutter/cupertino.dart';
import 'package:wallpaper_app/screens/home_page/home_page.dart';
import 'package:wallpaper_app/screens/splash_screen/splash_screen.dart';

import '../screens/search/search_wallpaper_page.dart';
import '../screens/detail_wallpaper_page.dart';

class AppRoutes{
  static final splash="/";
  static final homePage="/home_page";
  static final detailWallpaperPage="/detail_wallpaper_page";
  static final searchWallpaperPage="/search_wallpaper_page";
  static Map<String,WidgetBuilder>getRoutes()=>{
    splash:(_)=>SplashPage(),
    homePage:(_)=>HomePage(),
    detailWallpaperPage:(_)=>DetailWallpaperPage(),
    searchWallpaperPage:(_)=>SearchWallpaperPage()
  };
}