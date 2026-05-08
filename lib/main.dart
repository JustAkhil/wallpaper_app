import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/constants/app_routes.dart';
import 'package:wallpaper_app/data/remote/api_helper.dart';
import 'package:wallpaper_app/data/repository/wallpaper_repository.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_bloc.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TrendingBloc(
            wallpaperRepository: WallpaperRepository(apiHelper: ApiHelper()),
          ),
        ),
        BlocProvider(
          create: (_) => SearchBloc(
            wallpaperRepository: WallpaperRepository(apiHelper: ApiHelper()),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
