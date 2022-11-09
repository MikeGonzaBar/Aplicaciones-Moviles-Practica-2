import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/Auth/user_auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserAuthRepository authRepo = UserAuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<VerifyAuthEvent>(_authVerfication);
    on<AnonymousAuthEvent>(_authAnonymous);
    on<GoogleAuthEvent>(_authUser);
    on<SignOutEvent>(_signOut);
  }

  FutureOr<void> _authVerfication(event, emit) {
    // inicializar datos de la app
    if (authRepo.isAlreadyAuthenticated()) {
      emit(AuthSuccessState());
    } else {
      emit(UnAuthState());
    }
  }

  FutureOr<void> _signOut(event, emit) async {
    await authRepo.signOutFirebaseUser();

    emit(SignOutSuccessState());
  }

  FutureOr<void> _authUser(event, emit) async {
    emit(AuthAwaitingState());
    try {
      await authRepo.signInWithGoogle();
      emit(AuthSuccessState());
    } catch (e) {
      log("Error al autenticar: $e");
      emit(AuthErrorState());
    }
  }

  FutureOr<void> _authAnonymous(event, emit) {
    log('TO DO');
  }
}
