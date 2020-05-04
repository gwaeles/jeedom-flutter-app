
import 'dart:async';

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

import 'config_event.dart';
import 'config_state.dart';

///
/// Responsibility :
/// - Manage state of page
///
class ConfigBloc extends BlocEventStateBase<ConfigEvent, ConfigState> {

  ConfigBloc()
      : super(
    initialState: ConfigState.locations(),
  );

  @override
  Stream<ConfigState> eventHandler(ConfigEvent event, ConfigState currentState) async* {

    if (event.type == ConfigEventType.next){
      if (currentState.type == ConfigStateType.locations) {
        yield ConfigState.credentials();
      }
      else if (currentState.type == ConfigStateType.credentials) {
        yield ConfigState.dashboard();
      }
    }

    if (event.type == ConfigEventType.prev){
      if (currentState.type == ConfigStateType.credentials) {
        yield ConfigState.locations();
      }
    }

  }
}
