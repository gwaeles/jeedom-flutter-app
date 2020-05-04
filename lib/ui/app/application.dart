

import 'package:flutter/material.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_bloc.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/ui/auth/auth_screen.dart';
import 'package:flutter_app/ui/config/config_screen.dart';
import 'package:flutter_app/ui/signin/signin_screen.dart';
import 'package:flutter_app/ui/smarthome/dashboard_page.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';

import 'transition/route_builders.dart';
import 'theme.dart';


///
/// Responsibility :
/// - Global app blocs instantiation
/// - Routes manifest
///
class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocProvider<AuthenticationBloc>(
      blocBuilder: () => AuthenticationBloc.deft(),
      child: BlocProvider<UserBloc>(
        blocBuilder: () => UserBloc(),
        child: BlocProvider<JeedomBloc>(
          blocBuilder: () => JeedomBloc(),
          child: MaterialApp(
            title: 'Jeeboard',
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/signin':
                  return FadeInRoute(page: SigninScreen());
                  break;
                case '/config':
                  return FadeInRoute(page: ConfigScreen());
                  break;
                case '/dashboard':
                  return SlideFromRightRoute(
                    page: DashboardPage(),
                  );
                  break;
              }

              return FadeInRoute(page: AuthScreen());
            },
            home: AuthScreen(),
            theme: appTheme(context),
          ),
        ),
      ),
    );
  }
}
