
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/config/widgets/organisms/local_ip_field.dart';
import 'package:flutter_app/ui/config/widgets/organisms/remote_url_field.dart';

import 'form_container.dart';

///
/// Responsibility :
/// - Server form implementation
///
class ServerForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FormContainer(
      title: 'Jeedom server location',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LocalIpField(),
          SizedBox(height: 8),
          RemoteUrlField(),
        ],
      ),
    );
  }
}
