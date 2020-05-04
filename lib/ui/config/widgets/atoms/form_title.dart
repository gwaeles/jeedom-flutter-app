
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {

  final String label;

  FormTitle({this.label, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subhead.copyWith(
            fontSize: 20,
        ),
      )
    );
  }
}