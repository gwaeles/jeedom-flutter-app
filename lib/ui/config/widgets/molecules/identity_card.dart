

import 'package:flutter/material.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_event.dart';
import 'package:flutter_app/ui/config/widgets/organisms/identity.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';

class IdentityCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    AuthenticationBloc _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Column(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
              color: Colors.white12,
              borderRadius: new BorderRadius.all(
                  const Radius.circular(16.0)
              )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Identity(),
                ),
                SizedBox(width: 8),
                RaisedButton(
                  onPressed: () {
                    _authenticationBloc.emitEvent(AuthenticationEventLogout());
                    Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                  },
                  child: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.button
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36)),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}