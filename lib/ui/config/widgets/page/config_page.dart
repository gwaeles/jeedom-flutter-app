import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/services/user/bloc/user_bloc.dart';
import 'package:flutter_app/ui/app/runtime.dart';
import 'package:flutter_app/ui/config/bloc/config_bloc.dart';
import 'package:flutter_app/ui/config/bloc/config_event.dart';
import 'package:flutter_app/ui/config/bloc/config_state.dart';
import 'package:flutter_app/ui/config/widgets/molecules/credentials_form.dart';
import 'package:flutter_app/ui/config/widgets/molecules/identity_card.dart';
import 'package:flutter_app/ui/config/widgets/molecules/navigation_button_bar.dart';
import 'package:flutter_app/ui/config/widgets/molecules/server_form.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_lifecycle.dart';


///
/// Responsibility :
/// - Screen layout
/// - Layout animation
///
class ConfigPage extends StatefulWidget {

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> with
    TickerProviderStateMixin, BlocLifecycle {

  UserBloc _userBloc;
  ConfigBloc _configBloc;
  StreamSubscription _subscription;

  // Nav bar animation
  Animation _animationNavBar;
  AnimationController _animationNavBarController;

  // Form apparition animation
  Animation _animationForm;
  AnimationController _animationFormController;

  // Forms animation
  Animation _animationOut;
  Animation _animationIn;
  AnimationController _animationController;
  bool isBack;
  bool _canBeDragged;
  double maxSlide;
  double minDragStartEdge;
  double maxDragStartEdge;
  int index;

  // --- Bloc & animation lifecycle --- //

  @override
  void initState() {
    super.initState();

    index = 0;
    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (250 * Runtime.animationSpeed).round()),
    );

    // Form animation
    isBack = false;
    _canBeDragged = false;
    _animationOut = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.easeOut, parent: _animationController));
    _animationIn = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.easeIn, parent: _animationController));

    // Nav bar animation
    _animationNavBarController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (1 * Runtime.animationSpeed).round()),
    );
    _animationNavBar = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _animationNavBarController));

    Future.delayed(
        Duration(milliseconds: (300 * Runtime.animationSpeed).round()))
        .whenComplete(() {
      _animationNavBarController.forward();
    });

    // Form apparition animation
    _animationFormController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (1 * Runtime.animationSpeed).round()),
    );
    _animationForm = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _animationFormController));

    Future.delayed(
        Duration(milliseconds: (300 * Runtime.animationSpeed).round()))
        .whenComplete(() {
      _animationFormController.forward();
    });
  }


  void initBloc() {

    _configBloc = BlocProvider.of<ConfigBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    print('_configBloc.hashCode=${_configBloc.hashCode}');
    _subscription = _configBloc.state.listen((state) {
      if (state.type == ConfigStateType.locations) {
        setState(() {
          index = 0;
        });
        if (_animationController.isCompleted) {
          setState(() {
            isBack = true;
          });
          _animationController.reverse();
        }
        else if (_animationController.isAnimating && _animationController.velocity > 0) {
          setState(() {
            isBack = true;
          });
          _animationController.reverse();
        }
      }

      if (state.type == ConfigStateType.credentials) {
        setState(() {
          index = 1;
        });
        if (_animationController.isDismissed) {
          setState(() {
            isBack = false;
          });
          _animationController.forward();
        }
        else if (_animationController.isAnimating &&
            _animationController.velocity < 0) {
          setState(() {
            isBack = false;
          });
          _animationController.forward();
        }
      }
    });
  }

  void disposeBloc() {
    _subscription?.cancel();
    _configBloc = null;
    _userBloc = null;
  }

// --- End Bloc & animation lifecycle --- //

// --- Gesture --- //

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed;
    bool isDragCloseFromRight = _animationController.isCompleted;

    _canBeDragged = isDragCloseFromRight || isDragOpenFromLeft;
    maxSlide = MediaQuery.of(context).size.width;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      _animationController.value -= delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }

    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = -details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity)
          .whenComplete(() {

        _configBloc.emitEvent(_animationController.isCompleted
            ? ConfigEvent.next()
            : ConfigEvent.prev());
      });
    }
    else if (_animationController.value > 0.5) {
      _animationController.forward();
      _configBloc.emitEvent(ConfigEvent.next());
    }
    else {
      _animationController.reverse();
      _configBloc.emitEvent(ConfigEvent.prev());
    }
  }

// --- End Gesture --- //

  @override
  Widget build(BuildContext context) {

    final _anim = isBack ? _animationIn : _animationOut;
    final Function onPrevPressedCallback = index == 1
        ? (() => _configBloc.emitEvent(ConfigEvent.prev()))
        : null;
    final Function onNextPressedCallback = index == 0
        ? (() => _configBloc.emitEvent(ConfigEvent.next()))
        : (() {
          if (_userBloc.requestRoute('/dashboard')) {
            Future.delayed(
                Duration(milliseconds: (250 * Runtime.animationSpeed).round())
            ).whenComplete(() {
              Navigator.pushReplacementNamed(context, '/dashboard');
            });
          }
        });

    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
                      child: Hero(
                        tag: 'identity',
                        child: IdentityCard(),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                      animation: _animationFormController,
                      child: Center(
                          child: GestureDetector(
                            onHorizontalDragStart: _onDragStart,
                            onHorizontalDragUpdate: _onDragUpdate,
                            onHorizontalDragEnd: _onDragEnd,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 16.0),
                                  child:
                                  AnimatedBuilder(
                                      animation: _animationController,
                                      child: ServerForm(),
                                      builder: (context, child) {
                                        double width = MediaQuery.of(context).size.width;
                                        double slide = width * (0.0 - _anim.value);
                                        return Transform.translate(
                                          offset: Offset(slide, 0),
                                          child: child,
                                        );
                                      }
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 16.0),
                                  child:
                                  AnimatedBuilder(
                                      animation: _animationController,
                                      child: CredentialsForm(),
                                      builder: (context, child) {
                                        double width = MediaQuery.of(context).size.width;
                                        double slide = width * (1.0 - _anim.value);
                                        return Transform.translate(
                                          offset: Offset(slide, 0),
                                          child: child,
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                      builder: (context, child) {
                        double size = MediaQuery.of(context).size.width;
                        double slide = size * (1.0 - _animationForm.value);
                        return Transform.translate(
                          offset: Offset(slide, 0),
                          child: child,
                        );
                      }
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedBuilder(
                        animation: _animationNavBarController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                          child: NavigationButtonBar(
                            onPrevPressedCallback: onPrevPressedCallback,
                            onNextPressedCallback: onNextPressedCallback,
                          ),

                        ),
                        builder: (context, child) {
                          double size = 180;
                          double slide = size * (1.0 - _animationNavBar.value);
                          return Transform.translate(
                            offset: Offset(0, slide),
                            child: child,
                          );
                        }
                    ),
                  ),
                ]
            )
        )
    );
  }
}