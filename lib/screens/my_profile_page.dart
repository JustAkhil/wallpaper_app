import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/data/repository/firebase-repository.dart';

class MyProfilePage extends StatefulWidget {
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final Color primary =  Color(0xff5B4DFF);
  final Color bgColor =  Color(0xffF5F7FF);
  Color get primaryColor =>  Color(0xff08122E);

  String name = "";
  String email = "";
  String phone = "";
  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(FirebaseRepository.PREFS_USER_ID_KEY);

    if (id == null || id.isEmpty) return;

    final data =
    await FirebaseRepository.getInstance().getUserDetail(id: id);

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
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Update Profile Photo",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _sheetOption(
                      icon: Icons.camera_alt_rounded,
                      title: "Camera",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _sheetOption(
                      icon: Icons.photo_library_rounded,
                      title: "Gallery",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(FirebaseRepository.PREFS_USER_ID_KEY,"");

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // HEADER
          Container(
            height: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary,  Color(0xff7C74FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:  BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                 SizedBox(height: 10),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(18),

                          boxShadow: [

                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.07),

                              blurRadius: 14,

                              offset:
                               Offset(0, 7),
                            ),
                          ],
                        ),

                        child: IconButton(

                          onPressed: () {
                            Navigator.pop(context);
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
                      padding:  EdgeInsets.all(5),
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
                            ?  AssetImage("assets/image/image_avatar.png")
                            : NetworkImage(imgUrl),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: showImagePickerSheet,
                        child: Container(
                          padding:  EdgeInsets.all(8),
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff5B4DFF),
                          ),
                          child:  Icon(
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
                  style:  TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15,),
                Expanded(
                  child: Container(
                    margin:  EdgeInsets.symmetric(horizontal: 16),
                    padding:  EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 25,
                          offset:  Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _infoTile(Icons.person_outline, "Full Name", name),
                         SizedBox(height: 18),
                        _infoTile(Icons.email_outlined, "Email", email),
                         SizedBox(height: 18),
                        _infoTile(Icons.phone_outlined, "Phone", phone),

                         Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: logout,
                            child:  Text(
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
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      padding:  EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:  Color(0xffF7F8FF),
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
              style:  TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _sheetOption({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xffF7F8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xff5B4DFF), size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}