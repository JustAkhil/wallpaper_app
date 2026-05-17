class UserModel {
  String name;
  String email;
  String mobNo;
  String? imgUrl;

  UserModel({
    required this.email,
    this.imgUrl,
    required this.mobNo,
    required this.name,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      imgUrl: map['imgUrl']??"",
      mobNo: map['mobNo'],
      name: map['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'imgUrl': imgUrl??"",
      'mobNo': mobNo,
      'name': name,
    };
  }
}
