
import 'jeedom_entity.dart';

class Scenario implements JeedomEntity {
  final String id;
  final String name;
  final bool isActive;
  final String group;
  final String mode;
  final String object_id;
  final bool isVisible;
  final int order;
  final String description;
  final String type;
  final String state;
  final String lastLaunch; // "2020-04-20 12:34:29"

  Scenario({
    this.id,
    this.name,
    this.isActive,
    this.group,
    this.mode,
    this.object_id,
    this.isVisible,
    this.order,
    this.description,
    this.type,
    this.state,
    this.lastLaunch
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Scenario(
        id: null,
        name: null,
        isActive: false,
        group: null,
        mode: null,
        object_id: null,
        isVisible: null,
        order: 0,
        description: null,
        type: null,
        state: null,
        lastLaunch: null,
      );
    }

    return Scenario(
      id: json['id'],
      name: json['name'],
      isActive: json['isActive'] == '1',
      group: json['group'],
      mode: json['mode'],
      object_id: json['object_id'],
      isVisible: json['isVisible'] == '1',
      order: json['order'],
      description: json['description'],
      type: json['type'],
      state: json['state'],
      lastLaunch: json['lastLaunch'],
    );
  }
}