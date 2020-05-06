
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_event.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/ui/app/runtime.dart';
import 'package:flutter_app/ui/auth/widgets/page/auth_page.dart';
import 'package:flutter_app/ui/config/bloc/shared_state.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_lifecycle.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

///
/// Responsibility :
/// - Blocs link : User bloc subscription to authentication bloc
/// - Manage navigation
/// - Init screen template implementation
///
class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin, BlocLifecycle {

  SharedState _sharedState;
  StreamSubscription _authStateSubscription;
  StreamSubscription _userStateSubscription;
  StreamSubscription _linkSubscription;
  UserBloc _userBloc;
  AuthenticationBloc _authenticationBloc;

  // --- Bloc lifecycle --- //

  void initBloc() {

    _sharedState = Provider.of<SharedState>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    _sharedState.fromAuth = true;

    // Link
    _linkSubscription = _authenticationBloc.currentAuthInfo.listen(_userBloc.authInfoResult);

    // Init
    if (_authenticationBloc.lastState == null) {
      _authenticationBloc.emitEvent(AuthenticationEventSignInSilently());
    }

    // Navigation
    _authStateSubscription = _authenticationBloc.state.listen((state) {
      if (state.hasFailed) {
        Navigator.of(context).pushReplacementNamed('/signin');
      }
    });
    _userStateSubscription = _userBloc.state.listen((state) {
      if (state.loaded) {
        Future.delayed(Duration(milliseconds: (1100 * Runtime.animationSpeed).round()))
            .whenComplete(() {
          Navigator.pushReplacementNamed(context, '/config');
        });
      }
    });
  }

  void disposeBloc() {
    _authStateSubscription?.cancel();
    _userStateSubscription?.cancel();
    _linkSubscription?.cancel();
    _authenticationBloc = null;
    _userBloc = null;
  }

  @override
  Widget build(BuildContext pageContext) {

    return AuthPage();
  }
}