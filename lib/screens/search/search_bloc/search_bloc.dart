import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/data/models/wallpaper_model.dart';
import 'package:wallpaper_app/data/repository/wallpaper_repository.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_event.dart';
import 'package:wallpaper_app/screens/search/search_bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent,SearchState>{
  WallpaperRepository wallpaperRepository;
  SearchBloc({required this.wallpaperRepository}):super(SearchInitialState()){
    on<GetSearchWallpapersEvent>((event,emit)async{
      emit(SearchLoadingState());
      try{
        var data =await wallpaperRepository.getSearchWallpaper(mQuery: event.query,mColor:event.color,page: event.page);
        WallpaperDataModel wallpaperDataModel= WallpaperDataModel.fromJson(data);
        emit(SearchLoadedState(listPhotos: wallpaperDataModel.photos!, totalResults: wallpaperDataModel.total_results!));
      }catch(e){
        emit(SearchErrorState(errMsg: e.toString()));
      }
    });
    on<ClearSearchEvent>((event,emit){
        emit(SearchInitialState());
    });
  }
}