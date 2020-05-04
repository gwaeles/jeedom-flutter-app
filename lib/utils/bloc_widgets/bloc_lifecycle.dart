
import 'package:flutter/material.dart';

mixin BlocLifecycle<T extends StatefulWidget> on State<T> implements IBlocLifecycle {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    initBloc();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    disposeBloc();
    initBloc();
  }

  @override
  void dispose() {
    disposeBloc();
    super.dispose();
  }
}


abstract class IBlocLifecycle {
  void initBloc();
  void disposeBloc();
}