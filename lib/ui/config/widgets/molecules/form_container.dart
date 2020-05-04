
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/config/widgets/atoms/form_title.dart';

///
/// Responsibility :
/// - Common form layout & style
///
class FormContainer extends StatelessWidget {

  final String title;
  final Widget child;

  const FormContainer({Key key, this.title, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FormTitle(label: title),
        SizedBox(height: 8),
        Container(
            height: 282,
            decoration: new BoxDecoration(
                color: Colors.white12,
                borderRadius: new BorderRadius.all(
                    const Radius.circular(16.0)
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
              child: child,
            )
        ),
      ],
    );
  }

}