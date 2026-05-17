import 'package:wallpaper_app/data/models/user_model.dart';

abstract class AuthenticationEvent{}
class CreateUserEvent extends AuthenticationEvent{
  UserModel userModel;
  String pass;
  CreateUserEvent({required this.userModel,required this.pass});
}
class LoginUserEvent extends AuthenticationEvent{
  String email;
  String pass;
  LoginUserEvent({required this.email,required this.pass});
}
class ForgotPasswordEvent extends AuthenticationEvent{
  String email;
  ForgotPasswordEvent({required this.email});
}