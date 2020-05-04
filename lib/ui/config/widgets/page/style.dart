
import 'package:flutter/material.dart';

///
/// Responsibility :
/// - Styles dedicated to config screen
///
InputDecoration inputDecoration1({success: false, failed: false}) {

  if (failed) {
    return InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(4.0),
          borderSide: new BorderSide(),
        ),
        suffixIcon: Icon(
          Icons.error,
          color: Colors.redAccent,
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0)
    );
  }
  else if (success) {
    return InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(4.0),
          borderSide: new BorderSide(),
        ),
        suffixIcon: Icon(
          Icons.check_circle,
          color: Colors.lightGreen,
        ),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(4.0),
          borderSide: new BorderSide(color: Colors.lightGreen),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0)
    );
  }
  else {
    return InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(4.0),
          borderSide: new BorderSide(),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0)
    );
  }
}