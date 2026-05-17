abstract class AuthenticateState{}
class AuthenticateLoadingState extends AuthenticateState{}
class AuthenticationInitialState extends AuthenticateState{}
class AuthenticationErrorState extends AuthenticateState {
  String errMsg;
  AuthenticationErrorState({required this.errMsg});
}
class LoginSuccessState extends AuthenticateState{}
class CreateAccountSuccessState extends AuthenticateState{}
class ForgotEmailSuccessState extends AuthenticateState{}
