
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_bloc.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_event.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/ui/smarthome/widgets/container_object_list.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_lifecycle.dart';

class DashboardPage extends StatefulWidget {

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with BlocLifecycle {

  UserBloc _userBloc;
  JeedomBloc _jeedomBloc;
  StreamSubscription _subscription;
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void initBloc() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _jeedomBloc = BlocProvider.of<JeedomBloc>(context);

    _subscription = _userBloc.user.listen((user) {
      _jeedomBloc.emitEvent(JeedomEvent.init(user));
    });
  }

  void disposeBloc() {
    _subscription?.cancel();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 56, bottom: 8, left: 8, right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      //Navigator.pop(context);
                      SystemNavigator.pop();

                    },
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Object list'),
                  )
                ],
              ),
            ),
            Expanded(
              child: ContainerObjectList(),
            ),
          ],
        ),
      ),
    );
  }

}