
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_bloc.dart';
import 'package:flutter_app/ui/smarthome/widgets/scenario_item.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/services/jeedom/model/scenario.dart';

class ScenarioList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    JeedomBloc _jeedomBloc = BlocProvider.of<JeedomBloc>(context);

    return StreamBuilder<List<Scenario>>(
      stream: _jeedomBloc.scenarios,
      builder: (BuildContext context,
          AsyncSnapshot<List<Scenario>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Add...');
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return ScenarioItem(scenario: snapshot.data[index]);
          },
        );
      },
    );
  }
}