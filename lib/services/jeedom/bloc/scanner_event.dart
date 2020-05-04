import 'package:flutter/material.dart';

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

class ScannerEvent extends BlocEvent {
  ScannerEvent({
    @required this.type,
    this.ip: "",
  });

  final ScannerEventType type;
  final String ip;
}

enum ScannerEventType {
  start,
  stop,
  complete,
}