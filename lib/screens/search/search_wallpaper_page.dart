import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wallpaper_app/app_widgets/wallpaper_bg_widget.dart';
import 'package:wallpaper_app/data/models/wallpaper_model.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_event.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_state.dart';
import 'package:wallpaper_app/ui_helper/ui_helper.dart';

import '../../constants/app_routes.dart';

class SearchWallpaperPage extends StatefulWidget {
  @override
  State<SearchWallpaperPage> createState() => _SearchWallpaperPageState();
}

class _SearchWallpaperPageState extends State<SearchWallpaperPage> {
  bool isChecking = false;

  Future<void> checkInternet() async {
    setState(() {
      isChecking = true;
    });

    final bool result = await InternetConnectionCheckerPlus().hasConnection;

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
            "Still no internet connection",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
  }

  Map<String, dynamic>? query;

  ScrollController scrollController = ScrollController();

  num totalWallpaperCnt = 0;

  int totalNumPages = 1;

  int pageCnt = 1;

  List<PhotoModel> allWallpapers = [];

  bool isPaginationLoading = false;

  Color get bgColor => Color(0xffF5F7FF);

  Color get primaryColor => Color(0xff08122E);

  Color get accentColor => Color(0xff5B4DFF);

  Color get softTextColor => const Color(0xff6B7280);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      query =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      final searchQuery = query!["query"] as String;

      final searchColor = query!["color"] as String? ?? "";

      context.read<SearchBloc>().add(
        GetSearchWallpapersEvent(query: searchQuery, color: searchColor),
      );

      setState(() {});
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        totalNumPages = totalWallpaperCnt ~/ 15 + 1;

        if (pageCnt < totalNumPages && !isPaginationLoading) {
          isPaginationLoading = true;

          pageCnt++;

          context.read<SearchBloc>().add(
            GetSearchWallpapersEvent(
              query: query!["query"],
              color: query!["color"] ?? "",
              page: pageCnt,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        top: false,
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (_, state) {
            if (state is SearchLoadedState) {
              totalWallpaperCnt = state.totalResults;

              allWallpapers.addAll(state.listPhotos);

              isPaginationLoading = false;
            }
          },

          builder: (_, state) {
            if (query == null ||
                state is SearchLoadingState && allWallpapers.isEmpty) {
              return Center(
                child: Container(
                  width: 82,
                  height: 82,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: accentColor,
                    backgroundColor: const Color(0xffEEF0F6),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              );
            }
            if (state is SearchErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
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
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: 52,
                            color: accentColor,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          "Something went wrong",
                          textAlign: TextAlign.center,
                          style: mTextStyle25(
                            mFontWeight: FontWeight.bold,
                            mColor: primaryColor,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          state.errMsg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: softTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: isChecking ? null : checkInternet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              disabledBackgroundColor: accentColor.withOpacity(
                                0.7,
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
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
                                      strokeCap: StrokeCap.round,
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
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),

              child: ListView(
                controller: scrollController,

                physics: BouncingScrollPhysics(),

                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 14,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),

                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),
                  Text(
                    "${(query!["query"] as String)[0].toUpperCase()}${(query!["query"] as String).substring(1)}",

                    style: mTextStyle34(
                      mFontWeight: FontWeight.bold,
                    ).copyWith(color: primaryColor, fontSize: 34.0),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "$totalWallpaperCnt Wallpapers",

                    style: mTextStyle16(
                      mFontWeight: FontWeight.w500,
                    ).copyWith(color: Colors.grey.shade600),
                  ),

                  SizedBox(height: 24),
                  MasonryGridView.count(
                    padding: EdgeInsets.zero,

                    shrinkWrap: true,

                    physics: NeverScrollableScrollPhysics(),

                    crossAxisCount: 2,

                    mainAxisSpacing: 14,

                    crossAxisSpacing: 14,

                    itemCount: allWallpapers.length,

                    itemBuilder: (_, index) {
                      return SizedBox(
                        height: index % 2 == 0 ? 300 : 400,

                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),

                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.detailWallpaperPage,
                              arguments: allWallpapers[index],
                            );
                          },

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 20,
                                  offset: Offset(0, 12),
                                ),

                                BoxShadow(
                                  color: Colors.white.withOpacity(0.6),
                                  blurRadius: 8,
                                  offset: Offset(-2, -2),
                                ),
                              ],
                            ),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),

                              child: Stack(
                                fit: StackFit.expand,

                                children: [
                                  WallPaperBgWidget(
                                    imgUrl: allWallpapers[index].src!.portrait!,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.45),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
