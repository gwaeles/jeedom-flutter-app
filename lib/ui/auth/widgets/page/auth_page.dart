
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/ui/auth/widgets/atoms/custom_linear_progress_indicator.dart';
import 'package:flutter_app/ui/auth/widgets/organisms/animated_identity_card.dart';
import 'package:flutter_app/ui/auth/widgets/organisms/user_loading_status.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

///
/// Responsibility :
/// - Screen layout
///
class _AuthPageState extends State<AuthPage> {

  @override
  Widget build(BuildContext pageContext) {

    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 44.0, horizontal: 16.0),
                      child: AnimatedIdentityCard(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
                      child: UserLoadingStatus(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 56.0),
                      child: CustomLinearProgressIndicator(),
                    ),
                  ),
                ]
            )
        )
    );
  }
}