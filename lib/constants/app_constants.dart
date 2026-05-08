import 'dart:ui';

import 'package:wallpaper_app/data/models/cat_model.dart';

class AppConstants {
  static const String PEXEL_API_KEY =
      "DL3XsZm6wMxPmo6e2kEZ5aUR4WOUNMYlSGOs7pe6nmCnePMl5LoHsnvc";

  static const List<Map<String, dynamic>> mColors = [
    {"color": Color(0xfffdb6b8), "code": "fdb6b8"},
    {"color": Color(0xff4164e0), "code": "4164e0"},
    {"color": Color(0xff6241e0), "code": "6241e0"},
    {"color": Color(0xff6abebf), "code": "6abebf"},
    {"color": Color(0xff282929), "code": "282929"},
    {"color": Color(0xfffe9a0a), "code": "fe9a0a"},
    {"color": Color(0xffb548ee), "code": "b548ee"},
  ];
  static final List<MCatModel> mCategories = [
    MCatModel(url: "assets/image/abstract.jpg", title: "Abstract"),
    MCatModel(url: "assets/image/nature.jpg", title: "Nature"),
    MCatModel(url: "assets/image/space.jpg", title: "Space"),
    MCatModel(url: "assets/image/animal.jpg", title: "Animal"),
    MCatModel(url: "assets/image/car.jpg", title: "Car"),
    MCatModel(url: "assets/image/fish.jpg", title: "Fish"),
    MCatModel(url: "assets/image/dark.jpg", title: "Dark"),
    MCatModel(url: "assets/image/music.jpg", title: "Music"),
    MCatModel(url: "assets/image/flower.jpg", title: "Flower"),
    MCatModel(url: "assets/image/insect.jpg", title: "Bugs"),
  ];
}
