import 'dart:ui';

import 'package:wallpaper_app/data/models/cat_model.dart';

class AppConstants {
  static const String PEXEL_API_KEY =
      "DL3XsZm6wMxPmo6e2kEZ5aUR4WOUNMYlSGOs7pe6nmCnePMl5LoHsnvc";

  static const List<Map<String,dynamic>> mColors = [
    {
      "color":Color(0xfffdb6b8),
      "code":"fdb6b8"
    },
    {
      "color":Color(0xff4164e0),
      "code":"4164e0"

    },
    {
      "color":Color(0xff6241e0),
      "code":"6241e0"
    },
    {
      "color":Color(0xff6abebf),
      "code":"6abebf"
    },
    {
      "color":Color(0xff282929),
      "code":"282929"
    },
    {
      "color":Color(0xfffe9a0a),
      "code":"fe9a0a"
    },
    {
      "color":Color(0xffb548ee),
      "code":"b548ee"
    }
  ];
  static final List<MCatModel> mCategories = [
    MCatModel(url: "assets/image/abstract_image.jpg", title: "Abstract"),
    MCatModel(url: "assets/image/nature_image.jpg", title: "Nature"),
    MCatModel(url: "assets/image/space_image.jpg", title: "Space"),
    MCatModel(url: "assets/image/animal_image.jpg", title: "Animal"),
  ];
}
