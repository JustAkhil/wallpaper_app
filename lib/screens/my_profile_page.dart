import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/data/models/user_model.dart';
import 'package:wallpaper_app/data/repository/firebase-repository.dart';

import '../constants/app_routes.dart';

class MyProfilePage extends StatefulWidget {
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final Color primary = Color(0xff5B4DFF);
  final Color bgColor = Color(0xffF5F7FF);

  Color get primaryColor => Color(0xff08122E);
  File? selectedFile;

  String name = "";
  String email = "";
  String phone = "";
  String imgUrl = "";
  late Future<void> userFuture;

  Future<void> checkInternet() async {
    final result = await InternetConnection().hasInternetAccess;
    if (!result) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.networkErrorPage,
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkInternet();
    userFuture = loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(FirebaseRepository.PREFS_USER_ID_KEY);

    if (id == null || id.isEmpty) return;

    final snapshot = await FirebaseRepository.getInstance().getUserDetail(id: id);
    final data = snapshot.data()!;

    setState(() {
      name = data["name"] ?? "Guest User";
      email = data["email"] ?? "Not available";
      phone = data["mobNo"] ?? "Not added";
      imgUrl = data["imgUrl"] ?? "";
    });
  }

  void showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 18),

              Text(
                "Update Profile Photo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pickCropUploadImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                      child: isUploading?null:_sheetOption(
                        icon: Icons.camera_alt_rounded,
                        title: "Camera",
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        pickCropUploadImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      child: isUploading?null:_sheetOption(
                        icon: Icons.photo_library_rounded,
                        title: "Gallery",
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder(
        future: userFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 42,
                      width: 42,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,

                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                      ),
                    ),

                    SizedBox(height: 14),

                    Text(
                      "Loading Profile...",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong!"));
          }
          return Stack(
            children: [
              Container(
                height: 500,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, Color(0xff7C74FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),

              SafeArea(
                child: (name.isEmpty || email.isEmpty || phone.isEmpty)
                    ? Center()
                    : Column(
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,

                                    borderRadius: BorderRadius.circular(18),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.07),

                                        blurRadius: 14,

                                        offset: Offset(0, 7),
                                      ),
                                    ],
                                  ),

                                  child: IconButton(
                                    onPressed: () {
                                      Future.delayed(
                                        Duration(milliseconds: 300),
                                        () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },

                                    icon: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            "My Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 20),
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage: imgUrl.isEmpty
                                      ? AssetImage(
                                          "assets/image/image_avatar.png",
                                        )
                                      : NetworkImage(imgUrl),
                                  child: isUploading
                                      ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.50),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Color(0xff5B4DFF),
                                          ),
                                          backgroundColor: Colors.white.withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  )
                                      : null,
                                ),
                              ),

                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: showImagePickerSheet,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff5B4DFF),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 25,
                                    offset: Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _infoTile(
                                    Icons.person_outline,
                                    "Full Name",
                                    name,
                                  ),
                                  SizedBox(height: 18),
                                  _infoTile(
                                    Icons.email_outlined,
                                    "Email",
                                    email,
                                  ),
                                  SizedBox(height: 18),
                                  _infoTile(
                                    Icons.phone_outlined,
                                    "Phone",
                                    phone,
                                  ),

                                  Spacer(),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences.getInstance();
                                        prefs.setString(
                                          FirebaseRepository.PREFS_USER_ID_KEY,
                                          "",
                                        );
                                        Navigator.pushReplacementNamed(
                                          context,
                                          AppRoutes.loginPage,
                                        );
                                      },
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xffF7F8FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withOpacity(0.12),
            ),
            child: Icon(icon, color: primary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetOption({required IconData icon, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Color(0xffF7F8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xff5B4DFF), size: 30),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  pickCropUploadImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedImage == null) return;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      uiSettings: [
        AndroidUiSettings(
          cropFrameColor: Colors.transparent,
          cropStyle: CropStyle.circle,
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.square,
          backgroundColor: Colors.black,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(cropStyle: CropStyle.circle),
      ],
    );
    if (croppedFile == null) return;
    selectedFile = File(croppedFile.path);
    setState(() {
      isUploading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString(FirebaseRepository.PREFS_USER_ID_KEY)!;
      if (imgUrl.isNotEmpty) {
        await FirebaseRepository.getInstance().deleteOldImage(imgUrl);
      }
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference imgRef = storage
          .ref("profile_img")
          .child(id)
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");
      var imgByte = await selectedFile!.readAsBytes();
      UploadTask upload= imgRef.putData(imgByte);
      await upload;
      String url=await imgRef.getDownloadURL();
      UserModel user=UserModel(email: email, imgUrl: url, mobNo: phone, name: name);
      await FirebaseRepository.getInstance().update(id: id, user: user);
      setState(() {
        imgUrl=url;
        isUploading=false;
        selectedFile=null;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          _customSnackBar(
            message: "Profile photo updated!",
            icon: Icons.check_circle_rounded,
            colors: [Color(0xff5B4DFF), Color(0xff7C74FF)],
            textColor: Colors.white,
          ),
        );


    } catch (e) {
      setState(() {
        isUploading = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          _customSnackBar(
            message: e.toString(),
            icon: Icons.error_rounded,
            colors: const [
              Color(0xffFF6B6B),
              Color(0xffFF8E53),
            ],
            textColor: Colors.white,
          ),
        );
    }
  }

  bool isUploading = false;
  SnackBar _customSnackBar({
    required String message,
    required IconData icon,
    required List<Color> colors,
    required Color textColor,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(colors: colors),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.28),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
