import 'package:flutter/material.dart';
import 'package:flutter_app/ui/config/widgets/organisms/user_login_field.dart';

import 'form_container.dart';

///
/// Responsibility :
/// - Credentials form implementation
///
class CredentialsForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FormContainer(
      title: 'Jeedom credentials',
      child: UserLoginField(),
    );
  }
}
