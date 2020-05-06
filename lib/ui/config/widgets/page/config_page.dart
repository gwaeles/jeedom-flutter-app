import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/ui/app/runtime.dart';
import 'package:flutter_app/ui/app/transition/route_builders.dart';
import 'package:flutter_app/ui/config/bloc/config_bloc.dart';
import 'package:flutter_app/ui/config/bloc/config_event.dart';
import 'package:flutter_app/ui/config/bloc/shared_state.dart';
import 'package:flutter_app/ui/config/config_screen.dart';
import 'package:flutter_app/ui/config/widgets/molecules/identity_card.dart';
import 'package:flutter_app/ui/config/widgets/molecules/navigation_button_bar.dart';
import 'package:flutter_app/ui/config/widgets/organisms/animated_form.dart';
import 'package:flutter_app/ui/smarthome/dashboard_page.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:provider/provider.dart';


///
/// Responsibility :
/// - Screen layout
/// - Manage Nav bar actions
///
class ConfigPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    ConfigBloc _configBloc = BlocProvider.of<ConfigBloc>(context);

    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Consumer<SharedState>(
            builder: (context, sharedState, _) {
              final Function onPrevPressedCallback = sharedState.serverFormIndex == 1
                  ? (() => _configBloc.emitEvent(ConfigEvent.prev()))
                  : null;
              final Function onNextPressedCallback = sharedState.serverFormIndex == 0
                  ? (() => _configBloc.emitEvent(ConfigEvent.next()))
                  : (() {

                sharedState.fromAuth = false;

                Future.delayed(
                    Duration(milliseconds: (250 * Runtime.animationSpeed).round())
                ).whenComplete(() {
                  //Navigator.pushReplacementNamed(context, '/dashboard');

                  Navigator.pushReplacement(context, SlideFromRightRoute(
                    exitPage: context.findAncestorWidgetOfExactType<ConfigScreen>(),
                    page: DashboardPage(),
                  ));
                });
              });

              return Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 44.0, horizontal: 16.0),
                        child: Hero(
                          tag: 'identity',
                          child: IdentityCard(),
                        ),
                      ),
                    ),
                    AnimatedForm(
                      enableIncomingAnimation: sharedState.fromAuth,
                      serverFormIndex: sharedState.serverFormIndex,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:
                      NavigationButtonBar(
                        onPrevPressedCallback: onPrevPressedCallback,
                        onNextPressedCallback: onNextPressedCallback,
                        enableIncomingAnimation: sharedState.fromAuth,
                      ),
                    ),
                  ]
              );
            },
          ),
        )
    );
  }
}