
import 'package:flutter/material.dart';

class FieldTitle extends StatelessWidget {

  final String label;

  FieldTitle({this.label, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextStyle headlineForm = Theme.of(context).textTheme.headline.copyWith(
      color: Colors.white54,
      fontSize: 14.0,
    );

    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                label,
                style: headlineForm,
              ),
          )
        ]
    );
  }
}
