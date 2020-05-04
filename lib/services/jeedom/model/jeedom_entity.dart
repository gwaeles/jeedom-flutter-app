
import 'dart:core';

import 'container_object.dart';
import 'scenario.dart';

abstract class JeedomEntity {
  factory JeedomEntity.fromJson(Type type, dynamic json) {

    if (type == ContainerObject) {
      return ContainerObject.fromJson(json);
    }
    else if (type == Scenario) {
      return Scenario.fromJson(json);
    }

    throw Exception("JeedomEntity Type undefined $type");
  }
}