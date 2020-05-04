
import 'package:flutter/material.dart';
import 'package:flutter_app/services/jeedom/bloc/scanner_bloc.dart';
import 'package:flutter_app/services/jeedom/bloc/scanner_event.dart';
import 'package:flutter_app/services/jeedom/bloc/scanner_state.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/services/user/bloc/user_event.dart';
import 'package:flutter_app/ui/config/widgets/atoms/field_flat_button.dart';
import 'package:flutter_app/ui/config/widgets/atoms/field_title.dart';
import 'package:flutter_app/ui/config/widgets/page/style.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/services/user/model/user.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_lifecycle.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_state_builder.dart';

///
/// Responsibility :
/// - Server local ip field
/// - Bloc link : Update server local ip on scanner successful request
///
class LocalIpField extends StatefulWidget {
  @override
  _LocalIpFieldState createState() => _LocalIpFieldState();
}

class _LocalIpFieldState extends State<LocalIpField>
    with BlocLifecycle {

  UserBloc _userBloc;
  ScannerBloc _scannerBloc;

  void initBloc() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _scannerBloc = BlocProvider.of<ScannerBloc>(context);
  }

  void disposeBloc() {
    _userBloc = null;
    _scannerBloc = null;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User>(
        stream: _userBloc.user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

          TextEditingController localHostAddressController;
          if (snapshot.hasData
              && snapshot.data.server != null) {
            if (snapshot.data.server.localHostAddress != null) {
              localHostAddressController = TextEditingController(
                  text: snapshot.data.server.localHostAddress);
            }
          }

          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FieldTitle(
                  label: 'Local IP',
                ),
                BlocEventStateBuilder<ScannerState>(
                    bloc: _scannerBloc,
                    builder: (BuildContext context, ScannerState state) {
                      InputDecoration result;

                      if (state.isRunning) {
                        result = inputDecoration1().copyWith(
                            hintText: 'xxx.xxx.xxx.xxx',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _scannerBloc.emitEvent(ScannerEvent(
                                    type: ScannerEventType.stop
                                ));
                              },
                            )
                        );
                      }
                      else if (state.isSuccess) {
                        result = inputDecoration1(success: true).copyWith(
                          hintText: 'xxx.xxx.xxx.xxx',
                        );
                      }
                      else if (state.isFailure) {
                        result = inputDecoration1(failed: true).copyWith(
                            hintText: 'xxx.xxx.xxx.xxx',
                        );
                      }
                      else {
                        result = inputDecoration1().copyWith(
                            hintText: 'xxx.xxx.xxx.xxx'
                        );
                      }

                      return TextField(
                        controller: localHostAddressController,
                        style: TextStyle(color: Colors.black87),
                        decoration: result,
                        onChanged: (data) {
                          _userBloc.emitEvent(UserEvent.updateServerProperty(
                              UpdateServerPropertyParameters(
                                propertyName: ServerPropertyName.localHostAddress,
                                value: data,
                              )
                          ));
                        },
                      );
                    }
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FieldFlatButton(
                      onPressed: () {
                        _scannerBloc.emitEvent(ScannerEvent(
                          type: ScannerEventType.start,
                        ));
                      },
                      label: 'FIND',
                    ),
                    SizedBox(width: 4),
                    FieldFlatButton(
                      onPressed: () {
                        _scannerBloc.emitEvent(ScannerEvent(
                          type: ScannerEventType.start,
                          ip: localHostAddressController?.text,
                        ));
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
