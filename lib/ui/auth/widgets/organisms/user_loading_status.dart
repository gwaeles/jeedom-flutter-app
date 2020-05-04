
import 'package:flutter/material.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/services/user/bloc/user_state.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_state_builder.dart';

///
/// Responsibility :
/// - Display user loading info
///
class UserLoadingStatus extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);

    return BlocEventStateBuilder<UserState>(
        bloc: _userBloc,
        builder: (BuildContext context, UserState state){

          if (!state.initialized){
            return Text('Waiting auth...');
          }
          else if (state.loading){
            return Text('Loading user infos...');
          }
          else if (state.loaded){
            return Text('Ready...');
          }

          return Text('Initialized...');
        },
    );
  }

}