
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/jeedom/model/scenario.dart';

class ScenarioItem extends StatelessWidget {
  ScenarioItem({
    Key key,
    @required this.scenario,
  }) : super(key: key);

  final Scenario scenario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(scenario.name),
      subtitle: Text(scenario.lastLaunch),
    );
  }
}