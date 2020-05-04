
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_bloc.dart';
import 'package:flutter_app/services/jeedom/bloc/jeedom_event.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/services/jeedom/model/container_object.dart';

import 'container_object_item.dart';

class ContainerObjectList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    JeedomBloc _jeedomBloc = BlocProvider.of<JeedomBloc>(context);

    return StreamBuilder<List<ContainerObject>>(
      stream: _jeedomBloc.containers,
      builder: (BuildContext context,
          AsyncSnapshot<List<ContainerObject>> snapshot) {
        if (!snapshot.hasData) {
          _jeedomBloc.emitEvent(JeedomEvent.loadContainerObjects());
          return Text('Add...');
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return ContainerObjectItem(containerObject: snapshot.data[index]);
          },
        );
      },
    );
  }
}