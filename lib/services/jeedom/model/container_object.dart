
import 'jeedom_entity.dart';

class ContainerObject implements JeedomEntity {
  final String id;
  final String name;
  final String father_id;
  final bool isVisible;
  final String position;

  ContainerObject({
    this.id,
    this.name,
    this.father_id,
    this.isVisible,
    this.position,
  });

  factory ContainerObject.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return ContainerObject(
        id: null,
        name: null,
        father_id: null,
        isVisible: null,
        position: '0',
      );
    }

    return ContainerObject(
      id: json['id'],
      name: json['name'],
      father_id: json['father_id'],
      isVisible: json['isVisible'] == '1',
      position: json['position'],
    );
  }
}