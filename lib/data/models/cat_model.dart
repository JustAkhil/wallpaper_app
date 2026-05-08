class MCatModel{
  String? url;
  String title;
  MCatModel({this.url, required this.title});
  factory MCatModel.fromJson(Map<String,dynamic>json){
    return MCatModel(
      url: json["url"],
      title: json["title"],
    );
  }
}