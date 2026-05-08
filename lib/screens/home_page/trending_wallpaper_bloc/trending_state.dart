import 'package:wallpaper_app/data/models/wallpaper_model.dart';

abstract class TrendingState{}
class TrendingInitialState extends TrendingState{}
class TrendingLoadingState extends TrendingState{}
class TrendingLoadedState extends TrendingState{
  List<PhotoModel> listPhotos;
  TrendingLoadedState({required this.listPhotos});
}
class TrendingErrorState extends TrendingState{
  String errMsg;
  TrendingErrorState({required this.errMsg});
}