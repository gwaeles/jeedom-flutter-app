
import 'package:flutter/material.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_bloc.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_event.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/services/user/model/user.dart';
import 'package:flutter_app/ui/config/widgets/atoms/field_flat_button.dart';
import 'package:flutter_app/ui/config/widgets/atoms/field_title.dart';
import 'package:flutter_app/ui/config/widgets/page/style.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';

///
/// Responsibility :
/// - Login & password fields
/// - Request login on jeedom bloc
/// - Update user api key on success
///
class UserLoginField extends StatefulWidget {
  @override
  _UserLoginFieldState createState() => _UserLoginFieldState();
}

class _UserLoginFieldState extends State<UserLoginField> {

  bool showPassword;

  @override
  void initState() {
    super.initState();

    showPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    JeedomBloc _jeedomBloc = BlocProvider.of<JeedomBloc>(context);


    return StreamBuilder<User>(
        stream: _userBloc.user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot)
        {
          TextEditingController loginController;
          TextEditingController passwordController;// = TextEditingController();
          if (snapshot.hasData
              && snapshot.data.server != null) {
            if (snapshot.data.server.jeedomUser != null) {
              loginController = TextEditingController(
                  text: snapshot.data.server.jeedomUser);
            }
          }

          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FieldTitle(
                  label: 'Login',
                ),
                StreamBuilder<JeedomGetHashResult>(
                    stream: _jeedomBloc.getApiKey,
                    builder: (BuildContext context,
                        AsyncSnapshot<JeedomGetHashResult> snapshot) {
                      InputDecoration result;

                      if (snapshot.hasData &&
                          snapshot.data.state == JeedomRequestStatus.ok) {
                        result = inputDecoration1(success: true);
                      }
                      else if (snapshot.hasData &&
                          snapshot.data.state == JeedomRequestStatus.ko) {
                        result = inputDecoration1(failed: true);
                      }
                      else {
                        result = inputDecoration1();
                      }

                      return Column(
                        children: <Widget>[
                          TextField(
                            controller: loginController,
                            style: TextStyle(color: Colors.black87),
                            decoration: result,
                          ),
                          SizedBox(height: 16),
                          FieldTitle(
                            label: 'Password',
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: !showPassword,
                            style: TextStyle(color: Colors.black87),
                            decoration: result.copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: showPassword ? Theme.of(context).primaryColor : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                )
                            ),
                          ),
                        ],
                      );
                    }
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FieldFlatButton(
                      onPressed: () {
                        if (loginController?.text != null &&
                            passwordController?.text != null) {
                          _jeedomBloc.emitEvent(JeedomEvent.getApiKey(
                              loginController.text,
                              passwordController.text
                          ));
                        }
                      },
                      label: 'TEST',
                    ),
                  ],
                ),
              ]
          );
        }
    );
  }
}
