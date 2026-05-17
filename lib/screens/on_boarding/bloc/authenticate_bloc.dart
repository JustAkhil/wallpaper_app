import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/data/repository/firebase-repository.dart';
import 'package:wallpaper_app/screens/on_boarding/bloc/authenticate_event.dart';
import 'package:wallpaper_app/screens/on_boarding/bloc/authenticate_state.dart';

class AuthenticateBloc extends Bloc<AuthenticationEvent, AuthenticateState> {
  FirebaseRepository firebaseRepository;
  AuthenticateBloc({required this.firebaseRepository}) : super(AuthenticationInitialState()){
    on<LoginUserEvent>((event,emit)async{
      emit(AuthenticateLoadingState());
      try{
        await firebaseRepository.loginUser(email: event.email, pass: event.pass);
        emit(LoginSuccessState());
      }catch(e){
        emit(AuthenticationErrorState(errMsg: e.toString()));
      }
    });
    on<CreateUserEvent>((event,emit)async{
      emit(AuthenticateLoadingState());
      try{
        await firebaseRepository.createUser(user: event.userModel, pass: event.pass);
        emit(CreateAccountSuccessState());
      }catch(e){
        emit(AuthenticationErrorState(errMsg: e.toString()));
      }
    });
    on<ForgotPasswordEvent>((event,emit)async{
      emit(AuthenticateLoadingState());
      try{
        await firebaseRepository.forgotPassword(email:event.email);
      }catch(e){
        emit(AuthenticationErrorState(errMsg: e.toString()));
      }
    });
  }
}
