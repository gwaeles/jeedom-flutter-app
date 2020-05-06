
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/app/runtime.dart';

///
/// Responsibility :
/// - Manage transitions between screens
///
///
class SlideFromTopRoute extends PageRouteBuilder {
  final Widget page;

  SlideFromTopRoute({this.page})
      : super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,) => page,
    transitionDuration: Duration(milliseconds: (350 * Runtime.animationSpeed).round()),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

class SlideFromRightRoute extends PageRouteBuilder {
  final Widget exitPage;
  final Widget page;

  SlideFromRightRoute({this.exitPage, this.page}) : super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,) => page,
    transitionDuration: Duration(milliseconds: (350 * Runtime.animationSpeed).round()),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {

      return Stack(
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1, 0),
            ).animate(animation),
            child: exitPage,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(1, 0),
              ).animate(secondaryAnimation),
              child: child,
            ),
          )
        ],
      );
    },
  );
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return page;
      },
      transitionDuration: Duration(milliseconds: (350 * Runtime.animationSpeed).round()),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new ScaleTransition(
          scale: new Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: Curves.linear,
              ),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 1.5,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.50,
                  1.00,
                  curve: Curves.linear,
                ),
              ),
            ),
            child: child,
          ),
        );
      }
  );
}

class FadeInRoute extends PageRouteBuilder {
  final Widget page;

  FadeInRoute({this.page})
      : super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation,) => page,
    transitionDuration: Duration(milliseconds: (350 * Runtime.animationSpeed).round()),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}