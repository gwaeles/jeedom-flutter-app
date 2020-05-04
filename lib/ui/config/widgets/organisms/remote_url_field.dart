
import 'package:flutter/material.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_bloc.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_event.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/services/user/bloc/user_event.dart';
import 'package:flutter_app/ui/config/widgets/atoms/field_flat_button.dart';
import 'package:flutter_app/ui/config/widgets/atoms/field_title.dart';
import 'package:flutter_app/ui/config/widgets/page/style.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/services/user/model/user.dart';

class RemoteUrlField extends StatefulWidget {
  @override
  _RemoteUrlFieldState createState() => _RemoteUrlFieldState();
}

class _RemoteUrlFieldState extends State<RemoteUrlField> {

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    JeedomBloc _jeedomBloc = BlocProvider.of<JeedomBloc>(context);

    return StreamBuilder<User>(
        stream: _userBloc.user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

          TextEditingController remoteHostAddressController;
          if (snapshot.hasData
              && snapshot.data.server != null) {
            if (snapshot.data.server.remoteHostAddress != null) {
              remoteHostAddressController = TextEditingController(
                  text: snapshot.data.server.remoteHostAddress);
            }
          }

          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FieldTitle(
                  label: 'Remote access Url',
                ),
                StreamBuilder<JeedomRequestStatus>(
                    stream: _jeedomBloc.pingRemote,
                    builder: (BuildContext context, AsyncSnapshot<JeedomRequestStatus> snapshot) {
                      InputDecoration result;

                      if (snapshot.hasData && snapshot.data == JeedomRequestStatus.ok) {
                        result = inputDecoration1(success: true);
                      }
                      else if (snapshot.hasData && snapshot.data == JeedomRequestStatus.ko) {
                        result = inputDecoration1(failed: true);
                      }
                      else {
                        result = inputDecoration1();
                      }

                      return TextField(
                        controller: remoteHostAddressController,
                        onChanged: (data) {
                          _userBloc.emitEvent(UserEvent.updateServerProperty(
                              UpdateServerPropertyParameters(
                                propertyName: ServerPropertyName.remoteHostAddress,
                                value: data,
                              )
                          ));
                          if (snapshot.data != JeedomRequestStatus.idle) {
                            _jeedomBloc.emitEvent(JeedomEvent.resetPingRemote());
                          }
                        },
                        style: TextStyle(color: Colors.black87),
                        decoration: result,
                      );
                    }
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FieldFlatButton(
                      onPressed: () {
                        if (remoteHostAddressController?.text != null) {
                          _jeedomBloc.emitEvent(JeedomEvent.pingRemote(
                              remoteHostAddressController?.text
                          ));
                        }
                      },
                      label: 'PING',
                    ),
                  ],
                ),
              ]
          );
        }
    );
  }
}
