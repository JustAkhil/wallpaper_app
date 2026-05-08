import '../../../data/models/wallpaper_model.dart';

abstract class SearchState{}
class SearchInitialState extends SearchState{}
class SearchLoadingState extends SearchState{}
class SearchLoadedState extends SearchState{
  List<PhotoModel> listPhotos;
  num totalResults;
  SearchLoadedState({required this.listPhotos,required this.totalResults});
}
class SearchErrorState extends SearchState{
  String errMsg;
  SearchErrorState({required this.errMsg});
}