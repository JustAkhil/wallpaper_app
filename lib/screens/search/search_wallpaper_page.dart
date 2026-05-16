import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wallpaper_app/app_widgets/wallpaper_bg_widget.dart';
import 'package:wallpaper_app/constants/app_routes.dart';
import 'package:wallpaper_app/data/models/wallpaper_model.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_event.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_state.dart';
import 'package:wallpaper_app/ui_helper/ui_helper.dart';

class SearchWallpaperPage extends StatefulWidget {
  @override
  State<SearchWallpaperPage> createState() =>
      _SearchWallpaperPageState();
}

class _SearchWallpaperPageState
    extends State<SearchWallpaperPage> {

  Future<bool> hasInternet() async {
    return await InternetConnection().hasInternetAccess;
  }

  Map<String, dynamic>? query;

  ScrollController scrollController = ScrollController();

  num totalWallpaperCnt = 0;

  int totalNumPages = 1;

  int pageCnt = 1;

  List<PhotoModel> allWallpapers = [];

  bool isPaginationLoading = false;

  Color get bgColor => const Color(0xffF5F7FF);

  Color get primaryColor => const Color(0xff08122E);

  Color get accentColor => const Color(0xff5B4DFF);

  Color get softTextColor => const Color(0xff6B7280);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {

      final bool internet = await hasInternet();

      if (!internet) {

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.networkErrorPage,
        );

        return;
      }

      query =
      ModalRoute.of(context)!.settings.arguments
      as Map<String, dynamic>;

      final searchQuery = query!["query"] as String;

      final searchColor =
          query!["color"] as String? ?? "";

      context.read<SearchBloc>().add(
        GetSearchWallpapersEvent(
          query: searchQuery,
          color: searchColor,
        ),
      );

      setState(() {});
    });

    scrollController.addListener(() {

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {

        totalNumPages =
            totalWallpaperCnt ~/ 15 + 1;

        if (pageCnt < totalNumPages &&
            !isPaginationLoading) {

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

              totalWallpaperCnt =
                  state.totalResults;

              allWallpapers.addAll(
                state.listPhotos,
              );

              isPaginationLoading = false;
            }
          },

          builder: (_, state) {

            if (query == null ||
                state is SearchLoadingState &&
                    allWallpapers.isEmpty) {

              return Center(
                child: Container(
                  width: 82,
                  height: 82,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(26),

                    boxShadow: [
                      BoxShadow(
                        color:
                        accentColor.withOpacity(0.18),

                        blurRadius: 24,

                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),

                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: accentColor,
                    backgroundColor:
                    const Color(0xffEEF0F6),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              );
            }

            if (state is SearchErrorState) {

              Future.microtask(() {

                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.networkErrorPage,
                );
              });

              return const SizedBox();
            }

            return Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: ListView(
                controller: scrollController,

                physics:
                const BouncingScrollPhysics(),

                children: [

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(18),

                          boxShadow: [

                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.07),

                              blurRadius: 14,

                              offset:
                              const Offset(0, 7),
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

                  const SizedBox(height: 24),

                  Text(
                    "${(query!["query"] as String)[0].toUpperCase()}${(query!["query"] as String).substring(1)}",

                    style: mTextStyle34(
                      mFontWeight:
                      FontWeight.bold,
                    ).copyWith(
                      color: primaryColor,
                      fontSize: 34.0,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "$totalWallpaperCnt Wallpapers",

                    style: mTextStyle16(
                      mFontWeight:
                      FontWeight.w500,
                    ).copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  MasonryGridView.count(
                    padding: EdgeInsets.zero,

                    shrinkWrap: true,

                    physics:
                    const NeverScrollableScrollPhysics(),

                    crossAxisCount: 2,

                    mainAxisSpacing: 14,

                    crossAxisSpacing: 14,

                    itemCount: allWallpapers.length,

                    itemBuilder: (_, index) {

                      return SizedBox(
                        height:
                        index % 2 == 0
                            ? 300
                            : 400,

                        child: InkWell(

                          borderRadius:
                          BorderRadius.circular(28),

                          onTap: () {

                            Navigator.pushNamed(
                              context,
                              AppRoutes.detailWallpaperPage,
                              arguments:
                              allWallpapers[index],
                            );
                          },

                          child: Container(

                            decoration: BoxDecoration(

                              borderRadius:
                              BorderRadius.circular(28),

                              boxShadow: [

                                BoxShadow(
                                  color:
                                  Colors.black.withOpacity(0.12),

                                  blurRadius: 20,

                                  offset:
                                  const Offset(0, 12),
                                ),

                                BoxShadow(
                                  color:
                                  Colors.white.withOpacity(0.6),

                                  blurRadius: 8,

                                  offset:
                                  const Offset(-2, -2),
                                ),
                              ],
                            ),

                            child: ClipRRect(

                              borderRadius:
                              BorderRadius.circular(28),

                              child: Stack(
                                fit: StackFit.expand,

                                children: [

                                  WallPaperBgWidget(
                                    imgUrl:
                                    allWallpapers[index]
                                        .src!
                                        .portrait!,
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      gradient:
                                      LinearGradient(
                                        begin:
                                        Alignment.topCenter,

                                        end:
                                        Alignment.bottomCenter,

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

                  const SizedBox(height: 20),

                  if (isPaginationLoading)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),

                      child: Center(
                        child: CircularProgressIndicator(
                          color: accentColor,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}