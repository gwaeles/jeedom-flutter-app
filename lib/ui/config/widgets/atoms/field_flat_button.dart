
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FieldFlatButton extends StatelessWidget {

  final String label;
  final VoidCallback onPressed;

  const FieldFlatButton({Key key, this.label, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 50.0,
      child: FlatButton(
        onPressed: () {
          onPressed();
        },
        textTheme: ButtonTextTheme.accent,
        child: Text(label),
      ),
    );
  }

}