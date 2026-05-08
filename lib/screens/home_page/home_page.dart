import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/app_widgets/wallpaper_bg_widget.dart';
import 'package:wallpaper_app/constants/app_constants.dart';
import 'package:wallpaper_app/constants/app_routes.dart';
import 'package:wallpaper_app/data/models/wallpaper_model.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_bloc.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_event.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_state.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_event.dart';
import 'package:wallpaper_app/ui_helper/ui_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TrendingBloc>().add(GetTrendingWallpapersEvent());
  }

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: ListView(
        children: [
          Container(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Find Wallpaper...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 17),
                fillColor: AppColors.secondaryLightColor,
                filled: true,
                suffixIcon: InkWell(
                  onTap: (){
                    if(searchController.text.isNotEmpty){
                      context.read<SearchBloc>().add(ClearSearchEvent());
                      Navigator.pushNamed(context, AppRoutes.searchWallpaperPage,arguments: {
                        "query":searchController.text,
                      });
                      searchController.clear();
                    }
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 30,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              "Best of Month",
              style: mTextStyle16(mFontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 250,
            child: BlocBuilder<TrendingBloc, TrendingState>(
              builder: (_, state) {
                if (state is TrendingLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }else if(state is TrendingErrorState){
                  return Center(child: Text(state.errMsg));
                }else if(state is TrendingLoadedState){
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.listPhotos.length,
                    itemBuilder: (_, index) {
                      var photo=state.listPhotos[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: index == state.listPhotos.length - 1 ? 8 : 0,
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context,AppRoutes.detailWallpaperPage,arguments: photo);
                          },
                          child: WallPaperBgWidget(
                            imgUrl: photo.src!.portrait!,
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
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              "Color Tone",
              style: mTextStyle16(mFontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.mColors.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: index == AppConstants.mColors.length - 1 ? 8 : 0,
                  ),
                  child: InkWell(
                    onTap: (){
                      context.read<SearchBloc>().add(ClearSearchEvent());
                      Navigator.pushNamed(context, AppRoutes.searchWallpaperPage,arguments: {
                        "query":searchController.text.isNotEmpty?searchController.text:"Nature",
                        "color":AppConstants.mColors[index]["code"]
                      });
                      searchController.clear();
                    },
                    child: getColorToneWidget(
                      mColor: AppConstants.mColors[index]["color"],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              "Category",
              style: mTextStyle16(mFontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                crossAxisCount: 2,
                childAspectRatio: 9 / 5,
              ),
              itemCount: AppConstants.mCategories.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: (){
                    context.read<SearchBloc>().add(ClearSearchEvent());
                    Navigator.pushNamed(context, AppRoutes.searchWallpaperPage,arguments: {
                      "query":AppConstants.mCategories[index].title,
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
        ],
      ),
    );
  }

  Widget getColorToneWidget({Color? mColor}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: mColor,
        borderRadius: BorderRadius.circular(11),
      ),
    );
  }

  Widget getCategoryWidget({String? imgUrl, String? title}) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imgUrl!), fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Center(
        child: Text(
          title!,
          style: mTextStyle14(
            mColor: Colors.white,
            mFontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
