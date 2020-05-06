
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/ui/app/runtime.dart';
import 'package:flutter_app/ui/config/bloc/config_bloc.dart';
import 'package:flutter_app/ui/config/bloc/config_event.dart';
import 'package:flutter_app/ui/config/bloc/config_state.dart';
import 'package:flutter_app/ui/config/bloc/shared_state.dart';
import 'package:flutter_app/ui/config/widgets/molecules/credentials_form.dart';
import 'package:flutter_app/ui/config/widgets/molecules/server_form.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_lifecycle.dart';
import 'package:provider/provider.dart';

///
/// Responsibility :
/// - Server form layout
/// - Manage animations
///
class AnimatedForm extends StatefulWidget {

  final bool enableIncomingAnimation;
  final int serverFormIndex;

  AnimatedForm({Key key, this.enableIncomingAnimation, this.serverFormIndex}) : super(key: key);

  @override
  _AnimatedFormState createState() => _AnimatedFormState();
}

class _AnimatedFormState extends State<AnimatedForm> with
    TickerProviderStateMixin, BlocLifecycle {

  ConfigBloc _configBloc;
  StreamSubscription _subscription;

  // Form apparition animation
  Animation _animationForm;
  AnimationController _animationFormController;

  // Forms animation
  Animation _animationOut;
  Animation _animationIn;
  AnimationController _animationController;
  bool isBackwardAnimation;
  bool _canBeDragged;
  double maxSlide;
  double minDragStartEdge;
  double maxDragStartEdge;

  // --- Bloc & animation lifecycle --- //

  @override
  void initState() {
    super.initState();

    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (250 * Runtime.animationSpeed).round()),
    );

    // Form animation
    isBackwardAnimation = false;
    _canBeDragged = false;
    _animationOut = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.easeOut, parent: _animationController));
    _animationIn = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.easeIn, parent: _animationController));

    // Form apparition animation
    _animationFormController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (1 * Runtime.animationSpeed).round()),
    );
    _animationForm = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _animationFormController));

    if (widget.enableIncomingAnimation) {
      Future.delayed(
          Duration(milliseconds: (300 * Runtime.animationSpeed).round()))
          .whenComplete(() {
        _animationFormController.forward();
      });
    }
    else {
      _animationFormController.value = _animationFormController.upperBound;
      if (widget.serverFormIndex == 1) {
        _animationController.value = _animationController.upperBound;
      }
    }
  }

  void initBloc() {

    _configBloc = BlocProvider.of<ConfigBloc>(context);
    SharedState _sharedState = Provider.of<SharedState>(context);

    _subscription = _configBloc.state.listen((state) {
      if (state.type == ConfigStateType.locations) {
        _sharedState.serverFormIndex = 0;
        if (_animationController.isCompleted) {
          setState(() {
            isBackwardAnimation = true;
          });
          _animationController.reverse();
        }
        else if (_animationController.isAnimating && _animationController.velocity > 0) {
          setState(() {
            isBackwardAnimation = true;
          });
          _animationController.reverse();
        }
      }

      if (state.type == ConfigStateType.credentials) {
        _sharedState.serverFormIndex = 1;
        if (_animationController.isDismissed) {
          setState(() {
            isBackwardAnimation = false;
          });
          _animationController.forward();
        }
        else if (_animationController.isAnimating &&
            _animationController.velocity < 0) {
          setState(() {
            isBackwardAnimation = false;
          });
          _animationController.forward();
        }
      }
    });
  }

  void disposeBloc() {
    _subscription?.cancel();
    _configBloc = null;
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

    final _anim = isBackwardAnimation ? _animationIn : _animationOut;

    return AnimatedBuilder(
        animation: _animationFormController,
        child: Center(
            child: GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
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
                    padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
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
    );
  }
}