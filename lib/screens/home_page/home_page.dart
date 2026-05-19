import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/app_widgets/wallpaper_bg_widget.dart';
import 'package:wallpaper_app/constants/app_constants.dart';
import 'package:wallpaper_app/data/models/user_model.dart';
import 'package:wallpaper_app/data/repository/firebase-repository.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_bloc.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_event.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_state.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_event.dart';
import 'package:wallpaper_app/ui_helper/ui_helper.dart';

import '../../constants/app_routes.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  int selectedColorIndex = -1;

  Color get primaryColor => Color(0xff08122E);

  Color get accentColor => Color(0xff5B4DFF);

  Color get softTextColor => Color(0xff6B7280);

  Color get bgColor => Color(0xffF5F7FF);
  String? imgUrl;
  String? userId;

  @override
  void initState() {
    super.initState();
    context.read<TrendingBloc>().add(GetTrendingWallpapersEvent());
    userDetail();
  }

  Future<void> userDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(FirebaseRepository.PREFS_USER_ID_KEY)!;
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),

          children: [
            SizedBox(height: 22),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),

              child: Container(
                padding: EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(30),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),

                      blurRadius: 28,

                      offset: Offset(0, 14),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "WallNest",
                          style: mTextStyle16(
                            mColor: primaryColor,
                            mFontWeight: FontWeight.bold,
                          ).copyWith(fontSize: 34),
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Future.delayed(Duration(milliseconds: 300), () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.profilePage,
                                  );
                                });
                              },
                              child: userId == null
                                  ? CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage("assets/image/image_avatar.png"),
                              )
                                  : StreamBuilder(
                                stream: FirebaseRepository.getInstance()
                                    .getUserDetailAsAstream(id: userId!),
                                builder: (_, snapshot) {
                                  if (snapshot.hasData && snapshot.data!.data() != null) {
                                    var data = snapshot.data!.data();
                                    UserModel userModel = UserModel.fromMap(data!);
                                    imgUrl = userModel.imgUrl;
                                  }
                                  return CircleAvatar(
                                    radius: 40,
                                    backgroundImage: (imgUrl == null || imgUrl!.isEmpty)
                                        ? AssetImage("assets/image/image_avatar.png") as ImageProvider
                                        : NetworkImage(imgUrl!),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text("My Profile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.055),

                      blurRadius: 24,

                      offset: Offset(0, 14),
                    ),
                  ],
                ),

                child: TextField(
                  controller: searchController,

                  cursorColor: accentColor,

                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: "Search wallpapers...",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),

                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(20),

                      onTap: () async {
                        if (searchController.text.isNotEmpty) {
                          context.read<SearchBloc>().add(ClearSearchEvent());

                          await Navigator.pushNamed(
                            context,

                            AppRoutes.searchWallpaperPage,

                            arguments: {
                              "query": searchController.text,

                              "color": selectedColorIndex == -1
                                  ? ""
                                  : AppConstants
                                        .mColors[selectedColorIndex]["code"],
                            },
                          );

                          searchController.clear();

                          setState(() {
                            selectedColorIndex = -1;
                          });
                        }
                      },

                      child: Icon(Icons.search, color: softTextColor, size: 30),
                    ),

                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 22,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),

              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 25,

                    decoration: BoxDecoration(
                      color: accentColor,

                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Best of Month",

                    style: mTextStyle16(
                      mColor: primaryColor,
                      mFontWeight: FontWeight.bold,
                    ).copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            SizedBox(
              height: 250,

              child: BlocBuilder<TrendingBloc, TrendingState>(
                builder: (_, state) {
                  if (state is TrendingLoadingState) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 42,
                              width: 42,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,

                                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                              ),
                            ),

                            SizedBox(height: 14),

                            Text(
                              "Loading Wallpapers...",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is TrendingErrorState) {
                    return Center(child: Text(state.errMsg));
                  } else if (state is TrendingLoadedState) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,

                      physics: BouncingScrollPhysics(),

                      padding: EdgeInsets.symmetric(horizontal: 18),

                      itemCount: state.listPhotos.length,

                      itemBuilder: (_, index) {
                        var photo = state.listPhotos[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(24),

                          onTap: () {
                            Future.delayed(Duration(milliseconds: 300), () {
                              Navigator.pushNamed(
                                context,

                                AppRoutes.detailWallpaperPage,

                                arguments: photo,
                              );
                            });
                          },

                          child: Container(
                            width: 156,

                            margin: EdgeInsets.only(right: 14),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.13),

                                  blurRadius: 18,

                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),

                              child: Stack(
                                fit: StackFit.expand,

                                children: [
                                  WallPaperBgWidget(
                                    imgUrl: photo.src!.portrait!,
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.62),
                                        ],

                                        begin: Alignment.topCenter,

                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Container();
                },
              ),
            ),

            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),

              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 25,

                    decoration: BoxDecoration(
                      color: accentColor,

                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Color Tone",

                    style: mTextStyle16(
                      mColor: primaryColor,
                      mFontWeight: FontWeight.bold,
                    ).copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            SizedBox(
              height: 78,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                physics: BouncingScrollPhysics(),

                padding: EdgeInsets.symmetric(horizontal: 18),

                itemCount: AppConstants.mColors.length,

                itemBuilder: (_, index) {
                  bool isSelected = selectedColorIndex == index;

                  return InkWell(
                    borderRadius: BorderRadius.circular(24),

                    onTap: () {
                      setState(() {
                        selectedColorIndex = selectedColorIndex == index
                            ? -1
                            : index;
                      });
                    },

                    child: Container(
                      margin: EdgeInsets.only(right: 14),

                      child: getColorToneWidget(
                        mColor: AppConstants.mColors[index]["color"],

                        isSelected: isSelected,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),

              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 25,

                    decoration: BoxDecoration(
                      color: accentColor,

                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Categories",

                    style: mTextStyle16(
                      mColor: primaryColor,
                      mFontWeight: FontWeight.bold,
                    ).copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),

              child: GridView.builder(
                shrinkWrap: true,

                physics: NeverScrollableScrollPhysics(),

                itemCount: AppConstants.mCategories.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  mainAxisSpacing: 18,

                  crossAxisSpacing: 18,

                  childAspectRatio: 1.55,
                ),

                itemBuilder: (_, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(24),

                    onTap: () {
                      context.read<SearchBloc>().add(ClearSearchEvent());

                      Navigator.pushNamed(
                        context,

                        AppRoutes.searchWallpaperPage,

                        arguments: {
                          "query": AppConstants.mCategories[index].title,

                          "color": selectedColorIndex == -1
                              ? ""
                              : AppConstants
                                    .mColors[selectedColorIndex]["code"],
                        },
                      ).then((value) {
                        setState(() {
                          selectedColorIndex = -1;
                        });
                      });
                    },

                    child: getCategoryWidget(
                      imgUrl: AppConstants.mCategories[index].url!,

                      title: AppConstants.mCategories[index].title,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 34),
          ],
        ),
      ),
    );
  }

  Widget getColorToneWidget({required Color mColor, required bool isSelected}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 240),

      width: isSelected ? 68 : 58,

      height: isSelected ? 68 : 58,

      padding: EdgeInsets.all(5),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: isSelected ? Color(0xff7C74FF) : Color(0xffEEF0F6),

          width: isSelected ? 2.2 : 1,
        ),

        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Color(0xff7C74FF).withOpacity(0.28)
                : Colors.black.withOpacity(0.045),

            blurRadius: isSelected ? 22 : 10,

            offset: Offset(0, 8),
          ),
        ],
      ),

      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: mColor,

              borderRadius: BorderRadius.circular(18),
            ),
          ),

          if (isSelected)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),

                borderRadius: BorderRadius.circular(18),
              ),
            ),

          if (isSelected)
            Center(
              child: Icon(Icons.check_rounded, color: Colors.white, size: 28),
            ),
        ],
      ),
    );
  }

  Widget getCategoryWidget({String? imgUrl, String? title}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),

            blurRadius: 18,

            offset: Offset(0, 10),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),

        child: Stack(
          fit: StackFit.expand,

          children: [
            Image.asset(imgUrl!, fit: BoxFit.cover),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.04),
                    Colors.black.withOpacity(0.72),
                  ],

                  begin: Alignment.topCenter,

                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Positioned(
              top: 12,
              right: 12,

              child: Container(
                padding: EdgeInsets.all(7),

                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.28),

                  borderRadius: BorderRadius.circular(13),

                  border: Border.all(color: Colors.white.withOpacity(0.20)),
                ),

                child: Icon(
                  Icons.grid_view_rounded,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),

            Positioned(
              left: 14,
              right: 14,
              bottom: 14,

              child: Text(
                title!,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: mTextStyle14(
                  mColor: Colors.white,
                  mFontWeight: FontWeight.bold,
                ).copyWith(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
