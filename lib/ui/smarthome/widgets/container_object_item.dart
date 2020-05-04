
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/jeedom/model/container_object.dart';

class ContainerObjectItem extends StatelessWidget {
  ContainerObjectItem({
    Key key,
    @required this.containerObject,
  }) : super(key: key);

  final ContainerObject containerObject;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${containerObject.id} - ${containerObject.name}"),
    );
  }
}