
import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

class ConfigEvent extends BlocEvent {
  ConfigEvent({this.type});

  final ConfigEventType type;


  factory ConfigEvent.prev() {
    return ConfigEvent(type: ConfigEventType.prev);
  }

  factory ConfigEvent.next() {
    return ConfigEvent(type: ConfigEventType.next);
  }
}

enum ConfigEventType {
  prev,
  next,
}