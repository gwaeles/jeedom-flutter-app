
import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

class ConfigState extends BlocState {
  ConfigState({this.type});

  final ConfigStateType type;

  @override
  List<Object> get props => [type];

  factory ConfigState.locations() {
    return ConfigState(type: ConfigStateType.locations);
  }

  factory ConfigState.credentials() {
    return ConfigState(type: ConfigStateType.credentials);
  }

  factory ConfigState.dashboard() {
    return ConfigState(type: ConfigStateType.dashboard);
  }

}


enum ConfigStateType {
  locations,
  credentials,
  dashboard,
}