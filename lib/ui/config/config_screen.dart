import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_bloc.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_event.dart';
import 'package:flutter_app/services/jeedom/bloc/scanner_bloc.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/services/user/bloc/user_event.dart';
import 'package:flutter_app/ui/config/widgets/page/config_page.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_lifecycle.dart';

import 'bloc/config_bloc.dart';

///
/// Responsibility :
/// - Blocs & page instantiation
/// - Blocs link : Update server local ip on scanner successful request
/// - Blocs link : Update user infos on jeedom login successful request
/// - Blocs link : Update jeedom repositories on jeedom user updated
///
class ConfigScreen extends StatefulWidget {

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> with BlocLifecycle {

  UserBloc _userBloc;
  ConfigBloc _configBloc;
  ScannerBloc _scannerBloc;
  JeedomBloc _jeedomBloc;

  StreamSubscription _subscriptionScannerToUser;
  StreamSubscription _subscriptionJeedomToUser;
  StreamSubscription _subscriptionUserToJeedom;

  // --- Bloc lifecycle --- //

  void initBloc() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _configBloc = ConfigBloc();
    _scannerBloc = ScannerBloc();
    _jeedomBloc = BlocProvider.of<JeedomBloc>(context);

    // --- Blocs links --- //

    // Update server local ip on scanner successful request
    _subscriptionScannerToUser = _scannerBloc.scanner.listen((result) {
      _userBloc.emitEvent(UserEvent.updateServerProperty(
          UpdateServerPropertyParameters(
            propertyName: ServerPropertyName.localHostAddress,
            value: result.ip,
          )
      ));
    });

    // Update user login and api key on jeedom login successful request
    _subscriptionJeedomToUser = _jeedomBloc.getApiKey.listen((data) {
      _userBloc.emitEvent(UserEvent.updateServerProperty(
          UpdateServerPropertyParameters(
            propertyName: ServerPropertyName.apiKey,
            value: data.apiKey,
          )
      ));
      _userBloc.emitEvent(UserEvent.updateServerProperty(
          UpdateServerPropertyParameters(
            propertyName: ServerPropertyName.jeedomUser,
            value: data.jeedomUser,
          )
      ));
    });

    // Update jeedom repositories on jeedom user updated
    _subscriptionUserToJeedom = _userBloc.user.listen((user) {
      _jeedomBloc.emitEvent(JeedomEvent.init(user));
    });
  }

  void disposeBloc() {
    _subscriptionScannerToUser.cancel();
    _subscriptionJeedomToUser.cancel();
    _subscriptionUserToJeedom.cancel();
    _configBloc.dispose();
    _scannerBloc.dispose();
    _configBloc = null;
    _scannerBloc = null;
    _jeedomBloc = null;
    _userBloc = null;
  }

  // --- End Bloc lifecycle --- //

  @override
  Widget build(BuildContext context) {

    return BlocProvider<ConfigBloc>(
        blocBuilder: () => _configBloc,
        child: BlocProvider<ScannerBloc>(
            blocBuilder: () => _scannerBloc,
            child: ConfigPage()
        )
    );
  }

}