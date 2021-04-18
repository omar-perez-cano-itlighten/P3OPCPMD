import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_login/auth/user_auth_provider.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static final AuthBloc _authBloc = AuthBloc._internal();
  factory AuthBloc() {
    return _authBloc;
  }

  AuthBloc._internal() : super(AuthInitial());
  // atuh provider
  UserAuthProvider _authProvider = UserAuthProvider();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is VerifyAuthenticationEvent) {
      // requests a APIs
      // acceso a BD locales
      // revisar acceso a internet
      // lo que debamos hacer para inicializar datos de la app
      if (_authProvider.isAlreadyLogged())
        yield AlreadyAuthState();
      else
        yield UnAuthState();
    }
    if (event is SignOutAuthenticationEvent) {
      if (FirebaseAuth.instance.currentUser.isAnonymous)
        await _authProvider.signOutFirebase();
      else {
        await _authProvider.signOutFirebase();
        await _authProvider.signOutGoogle();
      }
      yield UnAuthState();
    }
  }
}
