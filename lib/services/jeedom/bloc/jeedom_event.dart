import 'package:flutter/material.dart';

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';
import 'package:flutter_app/services/user/model/user.dart';

class JeedomEvent extends BlocEvent {
  JeedomEvent({
    @required this.type,
    this.parameters: "",
  });

  final JeedomEventType type;
  final dynamic parameters;

  // --- Config --- //

  factory JeedomEvent.pingRemote(String url) {
    return JeedomEvent(
      type: JeedomEventType.pingRemote,
      parameters: url,
    );
  }

  factory JeedomEvent.pingLocal(String url) {
    return JeedomEvent(
      type: JeedomEventType.pingLocal,
      parameters: url,
    );
  }

  factory JeedomEvent.resetPingLocal() {
    return JeedomEvent(
        type: JeedomEventType.resetPingLocal
    );
  }

  factory JeedomEvent.resetPingRemote() {
    return JeedomEvent(
        type: JeedomEventType.resetPingRemote
    );
  }

  factory JeedomEvent.getApiKey(String login, String password) {
    return JeedomEvent(
        type: JeedomEventType.getApiKey,
        parameters: Credentials(login, password)
    );
  }

  // --- Dashboard --- //

  factory JeedomEvent.init(User user) {
    return JeedomEvent(
      type: JeedomEventType.init,
      parameters: user,
    );
  }

  factory JeedomEvent.loadScenario() {
    return JeedomEvent(
      type: JeedomEventType.loadScenarios,
    );
  }

  factory JeedomEvent.loadContainerObjects() {
    return JeedomEvent(
      type: JeedomEventType.loadContainerObjects,
    );
  }
}

enum JeedomEventType {
  init,
  pingLocal,
  resetPingLocal,
  pingRemote,
  resetPingRemote,
  getApiKey,
  loadContainerObjects,
  loadScenarios,
}

class Credentials {
  final String login;
  final String password;

  Credentials(this.login, this.password);
}