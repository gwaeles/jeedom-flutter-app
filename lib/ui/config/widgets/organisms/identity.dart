
import 'package:flutter/material.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app/services/authentication/model/auth_info.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';

///
/// Responsibility :
/// - Display authenticated user infos
///
class Identity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);

    return StreamBuilder<AuthInfo>(
      stream: bloc.currentAuthInfo,
      builder: (BuildContext context, AsyncSnapshot<AuthInfo> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                snapshot.data.userName,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                snapshot.data.userEmail,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54),
              ),
            ]
        );
      },
    );
  }
}
