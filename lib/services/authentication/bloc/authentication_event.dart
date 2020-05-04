

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

abstract class AuthenticationEvent extends BlocEvent {}

class AuthenticationEventSignInSilently extends AuthenticationEvent {}

class AuthenticationEventSignIn extends AuthenticationEvent {}

class AuthenticationEventLogout extends AuthenticationEvent {}
