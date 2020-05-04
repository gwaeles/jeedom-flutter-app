
import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

class JeedomState extends BlocState {
  JeedomState({
    this.idle: false,
    this.initializing: false,
    this.ready: false,
    this.error: false,
  });

  final bool idle;
  final bool initializing;
  final bool ready;
  final bool error;

  @override
  List<Object> get props => [idle, initializing, ready, error];

  factory JeedomState.newInstance() {
    return JeedomState(idle: true);
  }

  factory JeedomState.initializing(){
    return JeedomState(initializing: true);
  }

  factory JeedomState.ready(){
    return JeedomState(ready: true);
  }

  factory JeedomState.error(){
    return JeedomState(error: true);
  }

}