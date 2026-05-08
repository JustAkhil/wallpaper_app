abstract class SearchEvent{}
class GetSearchWallpapersEvent extends SearchEvent{
  String query;
  String color;
  int page;
  GetSearchWallpapersEvent({required this.query,this.color="",this.page=1});
}
class ClearSearchEvent extends SearchEvent{}