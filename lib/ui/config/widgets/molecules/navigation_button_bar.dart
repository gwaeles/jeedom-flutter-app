
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/app/runtime.dart';

///
/// Responsibility :
/// - Nav bar layout
///
class NavigationButtonBar extends StatefulWidget {

  final Function onPrevPressedCallback;
  final Function onNextPressedCallback;
  final bool enableIncomingAnimation;

  NavigationButtonBar({Key key, this.onPrevPressedCallback, this.onNextPressedCallback, this.enableIncomingAnimation}) : super(key: key);

  @override
  _NavigationButtonBarState createState() => _NavigationButtonBarState();
}

class _NavigationButtonBarState extends State<NavigationButtonBar> with
    TickerProviderStateMixin {

  // Nav bar animation
  Animation _animationNavBar;
  AnimationController _animationNavBarController;

  @override
  void initState() {
    super.initState();

    // Nav bar animation
    _animationNavBarController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (1 * Runtime.animationSpeed).round()),
    );
    _animationNavBar = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _animationNavBarController));

    if (widget.enableIncomingAnimation) {
      Future.delayed(
          Duration(milliseconds: (300 * Runtime.animationSpeed).round()))
          .whenComplete(() {
        _animationNavBarController.forward();
      });
    }
    else {
      _animationNavBarController.value = _animationNavBarController.upperBound;
    }
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: _animationNavBarController,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              RaisedButton(
                onPressed: widget.onPrevPressedCallback,
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
                onPressed: widget.onNextPressedCallback,
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
          )
        ),
        builder: (context, child) {
          double size = 180;
          double slide = size * (1.0 - _animationNavBar.value);
          return Transform.translate(
            offset: Offset(0, slide),
            child: child,
          );
        }
    );
  }

}