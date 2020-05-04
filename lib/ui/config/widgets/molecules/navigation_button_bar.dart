
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationButtonBar extends StatelessWidget {

  final Function onPrevPressedCallback;
  final Function onNextPressedCallback;

  const NavigationButtonBar({Key key, this.onPrevPressedCallback, this.onNextPressedCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        RaisedButton(
          onPressed: onPrevPressedCallback,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Prev',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36)),
        ),
        SizedBox(width: 8),
        RaisedButton(
          onPressed: onNextPressedCallback,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Next',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36)),
        ),
      ],
    );
  }

}