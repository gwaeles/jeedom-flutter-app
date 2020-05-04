import 'package:flutter/material.dart';

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

class UserEvent extends BlocEvent {
  UserEvent({
    @required this.type,
    this.parameters: "",
  });

  final UserEventType type;
  final dynamic parameters;

  factory UserEvent.init() {
    return UserEvent(type: UserEventType.init);
  }

  factory UserEvent.load() {
    return UserEvent(type: UserEventType.load);
  }

  factory UserEvent.save() {
    return UserEvent(type: UserEventType.save);
  }

  factory UserEvent.prev() {
    return UserEvent(type: UserEventType.prev);
  }

  factory UserEvent.next() {
    return UserEvent(type: UserEventType.next);
  }

  factory UserEvent.updateServerProperty(UpdateServerPropertyParameters params) {
    return UserEvent(
      type: UserEventType.updateServerProperty,
      parameters: params,
    );
  }
}

enum UserEventType {
  init,
  load,
  save,
  updateServerProperty,
  prev,
  next,
}

class UpdateServerPropertyParameters {
  UpdateServerPropertyParameters({
    this.propertyName,
    this.value,
  });

  final ServerPropertyName propertyName;
  final String value;
}

enum ServerPropertyName {
  localHostAddress,
  remoteHostAddress,
  jeedomUser,
  apiKey,
}