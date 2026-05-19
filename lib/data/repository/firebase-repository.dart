import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/data/models/user_model.dart';

class FirebaseRepository {
  FirebaseRepository._();

  static FirebaseRepository getInstance() => FirebaseRepository._();
  static const String USER_COLLECTION = "user";
  static const String PREFS_USER_ID_KEY = "uid";
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  Future<void> createUser({
    required UserModel user,
    required String pass,
  }) async {
    try {
      UserCredential userCredential = await fireAuth
          .createUserWithEmailAndPassword(email: user.email, password: pass);
      if (userCredential.user != null) {
        await fireStore
            .collection(USER_COLLECTION)
            .doc(userCredential.user!.uid)
            .set(user.toMap());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        throw "Email already exists";
      } else if (e.code == 'invalid-email') {
        throw "Invalid Email";
      } else {
        throw e.message ?? "Signup failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> loginUser({required String email, required String pass}) async {
    try {
      UserCredential userCredential = await fireAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(PREFS_USER_ID_KEY, userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw "Invalid email or password";
      } else if (e.code == 'invalid-email') {
        throw "Invalid email format";
      } else if (e.code == 'user-disabled') {
        throw "Account disabled";
      } else if (e.code == 'too-many-requests') {
        throw "Too many attempts. Try later";
      } else {
        throw "Login failed. Try again";
      }
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await fireAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw "Something Went Wrong";
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetail({
    required String id,
  }) async {
    return await fireStore.collection(USER_COLLECTION).doc(id).get();
  }
  Future<void> update({
    required String id,
    required UserModel user,
  }) async {
    await fireStore.collection(USER_COLLECTION).doc(id).update(user.toMap());
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDetailAsAstream({required String id}){
    return fireStore.collection(USER_COLLECTION).doc(id).snapshots();
  }
  Future<void> deleteOldImage(String oldUrl) async {
    try {
      if (oldUrl.isEmpty) return;
      Reference oldRef = FirebaseStorage.instance.refFromURL(oldUrl);
      await oldRef.delete();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> sendPasswordResetLink({required String email}) async {
    try {
      await fireAuth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw "No user found with this email";
        case 'invalid-email':
          throw "Invalid email format";
        case 'too-many-requests':
          throw "Too many attempts. Try again later";
        default:
          throw e.message ?? "Something went wrong";
      }
    } catch (e) {
      throw "Unexpected error occurred";
    }
  }}
