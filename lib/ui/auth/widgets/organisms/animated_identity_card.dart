

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/services/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_app/ui/app/runtime.dart';
import 'package:flutter_app/ui/config/widgets/molecules/identity_card.dart';
import 'package:flutter_app/utils/bloc_helpers/bloc_provider.dart';
import 'package:flutter_app/utils/bloc_widgets/bloc_lifecycle.dart';

class AnimatedIdentityCard extends StatefulWidget {
  @override
  _AnimatedIdentityCardState createState() => _AnimatedIdentityCardState();
}

///
/// Responsibility :
/// - Identity widget animation
///
class _AnimatedIdentityCardState extends State<AnimatedIdentityCard>
    with SingleTickerProviderStateMixin, BlocLifecycle {

  AuthenticationBloc _authenticationBloc;

  Animation _animation;
  AnimationController _animationController;
  StreamSubscription _animationSubscription;

  // --- Bloc & animation lifecycle --- //

  @override
  void initState() {
    super.initState();

    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (1 * Runtime.animationSpeed).round()),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _animationController));
  }

  void initBloc() {

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    _animationSubscription = _authenticationBloc.currentAuthInfo.listen((data) {
      if (data?.userId != null && _animationController.isDismissed) {
        _animationController.forward();
      }
    });
  }

  void disposeBloc() {
    _animationSubscription?.cancel();
  }


  @override
  Widget build(BuildContext pageContext) {

    return AnimatedBuilder(
        animation: _animationController,
        child: Hero(
          tag: 'identity',
          child: IdentityCard(),
        ),
        builder: (context, child) {
          double size = 180;
          double slide = -size * (1.0 - _animation.value);
          return Transform.translate(
            offset: Offset(0, slide),
            child: child,
          );
        }
    );
  }
}