
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_event.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_lifecycle.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

///
/// Responsibility :
/// - Sign in screen
///
class _SigninScreenState extends State<SigninScreen>
    with SingleTickerProviderStateMixin, BlocLifecycle {

  StreamSubscription _authStateSubscription;
  AuthenticationBloc _authenticationBloc;

  // --- Bloc lifecycle --- //

  void initBloc() {

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    _authStateSubscription = _authenticationBloc.state.listen((state) {
      if (state.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
  }

  void disposeBloc() {
    _authStateSubscription?.cancel();
    _authenticationBloc = null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 150),
                  SizedBox(height: 50),
                  RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      _authenticationBloc.emitEvent(AuthenticationEventSignIn());
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 11, 1, 11),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    elevation: 5,
                    shape: StadiumBorder(),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}