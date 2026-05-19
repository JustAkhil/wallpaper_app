import 'package:flutter/cupertino.dart';
import 'package:wallpaper_app/screens/home_page/home_page.dart';
import 'package:wallpaper_app/screens/my_profile_page.dart';
import 'package:wallpaper_app/screens/splash_screen/splash_screen.dart';

import '../screens/network_error.dart';
import '../screens/on_boarding/forget_pass_page.dart';
import '../screens/on_boarding/login/login_page.dart';
import '../screens/on_boarding/signup/signup_page.dart';
import '../screens/search/search_wallpaper_page.dart';
import '../screens/detail_wallpaper_page.dart';

class AppRoutes{
  static final splash="/splash";
  static final homePage="/home_page";
  static final detailWallpaperPage="/detail_wallpaper_page";
  static final searchWallpaperPage="/search_wallpaper_page";
  static final networkErrorPage="/network_error_page";
  static final loginPage="/login_page";
  static final signupPage="/signup_page";
  static final profilePage="/profile_page";
  static final forgotPasswordPage="/forgot_password_page";
  static Map<String,WidgetBuilder>getRoutes()=>{
    splash:(_)=>SplashPage(),
    homePage:(_)=>HomePage(),
    detailWallpaperPage:(_)=>DetailWallpaperPage(),
    searchWallpaperPage:(_)=>SearchWallpaperPage(),
    networkErrorPage:(_)=>NetworkErrorPage(),
    loginPage:(_)=>LoginPage(),
    signupPage:(_)=>SignupPage(),
    profilePage:(_)=>MyProfilePage(),
    forgotPasswordPage:(_)=>ForgotPasswordPage(),
  };
}