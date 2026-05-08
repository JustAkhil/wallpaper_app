import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  Map<String, dynamic>? query;
  ScrollController? scrollController=ScrollController();
  num totalWallpaperCnt=0;
  int totalNumPages=1;
  int pageCnt=1;
  List<PhotoModel>allWallpapers=[];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      query =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final searchQuery = query!["query"] as String;
      final searchColor = query!["color"] as String? ?? "";

      context.read<SearchBloc>().add(
        GetSearchWallpapersEvent(query: searchQuery,color: searchColor),
      );

      setState(() {});
    });
    scrollController!.addListener((){
      if(scrollController!.position.pixels==scrollController!.position.maxScrollExtent){
        totalNumPages=totalWallpaperCnt~/15+1;
        if(pageCnt<totalNumPages){
          pageCnt++;
          context.read<SearchBloc>().add(
            GetSearchWallpapersEvent(query: query!["query"],color: query!["color"]??"",page: pageCnt),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,

      body: BlocConsumer<SearchBloc, SearchState>(
        listener: (_, state) {
          if (state is SearchLoadedState) {
            totalWallpaperCnt = state.totalResults;
            allWallpapers.addAll(state.listPhotos);
          }
        },
        builder: (_, state) {
          if (query == null || state is SearchLoadingState && allWallpapers.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is SearchErrorState) {
            return Center(child: Text(state.errMsg));
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ListView(
              controller: scrollController,
              children: [
                SizedBox(height: 7),

                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryLightColor,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                  ],
                ),

                Text(
                  "${(query!["query"] as String)[0].toUpperCase()}${(query!["query"] as String).substring(1)}",
                  style: mTextStyle34(mFontWeight: FontWeight.bold),
                ),

                Text(
                  "$totalWallpaperCnt Wallpapers",
                  style: mTextStyle16(mFontWeight: FontWeight.w500),
                ),

                SizedBox(height: 10),

                MasonryGridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 11,
                  crossAxisSpacing: 11,
                  itemCount: allWallpapers.length,
                  itemBuilder: (_, index) {
                    return SizedBox(
                      height: index % 2 == 0 ? 300 : 400,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, AppRoutes.detailWallpaperPage,arguments: allWallpapers[index]);
                        },
                        child: WallPaperBgWidget(
                          imgUrl: allWallpapers[index].src!.portrait!,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
