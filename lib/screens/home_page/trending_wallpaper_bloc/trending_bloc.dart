import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/data/models/wallpaper_model.dart';
import 'package:wallpaper_app/data/repository/wallpaper_repository.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_event.dart';
import 'package:wallpaper_app/screens/home_page/trending_wallpaper_bloc/trending_state.dart';

class TrendingBloc extends Bloc<TrendingEvent,TrendingState>{
  WallpaperRepository wallpaperRepository;
  TrendingBloc({required this.wallpaperRepository}):super(TrendingInitialState()){
    on<GetTrendingWallpapersEvent>((event,emit)async{
      emit(TrendingLoadingState());
      try{
        var data= await wallpaperRepository.getTrendingWallpaper();
        WallpaperDataModel wallpaperDataModel= WallpaperDataModel.fromJson(data);
        emit(TrendingLoadedState(listPhotos: wallpaperDataModel.photos!));
      }catch(e){
        emit(TrendingErrorState(errMsg: e.toString()));
      }
    });
  }
}