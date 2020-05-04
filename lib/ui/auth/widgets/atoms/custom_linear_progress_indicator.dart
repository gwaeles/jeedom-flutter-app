

import 'package:flutter/material.dart';

///
/// Responsibility :
/// - Progress indicator with custom color
///
class CustomLinearProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(accentColor: Color.fromARGB(255, 169, 02, 57)),
      child: new LinearProgressIndicator(),
    );
  }
}